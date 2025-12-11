/**
 * Example Lambda configuration loader for Gadgetcloud.io (Node.js)
 * Demonstrates how to load SSM parameters in Lambda functions
 */
const { SSMClient, GetParameterCommand, GetParametersByPathCommand } = require('@aws-sdk/client-ssm');

const ssmClient = new SSMClient({});

class ConfigLoader {
    constructor(environment = null) {
        this.environment = environment || process.env.ENVIRONMENT || 'dev';
        this.projectName = 'gadgetcloud';
        this.basePath = `/${this.projectName}/${this.environment}`;
        this.cache = new Map();
    }

    /**
     * Get a single parameter value
     * @param {string} key - Parameter key (e.g., 'database/host')
     * @param {boolean} decrypt - Whether to decrypt SecureString parameters
     * @returns {Promise<string>} Parameter value
     */
    async getParameter(key, decrypt = false) {
        const cacheKey = `${key}:${decrypt}`;

        if (this.cache.has(cacheKey)) {
            return this.cache.get(cacheKey);
        }

        const parameterName = `${this.basePath}/${key}`;

        try {
            const command = new GetParameterCommand({
                Name: parameterName,
                WithDecryption: decrypt
            });

            const response = await ssmClient.send(command);
            const value = response.Parameter.Value;

            this.cache.set(cacheKey, value);
            return value;
        } catch (error) {
            if (error.name === 'ParameterNotFound') {
                throw new Error(`Parameter not found: ${parameterName}`);
            }
            throw error;
        }
    }

    /**
     * Get all parameters under a path
     * @param {string} path - Path prefix (e.g., 'database' or 'api')
     * @param {boolean} decrypt - Whether to decrypt SecureString parameters
     * @returns {Promise<Object>} Dictionary of parameter names to values
     */
    async getParametersByPath(path, decrypt = false) {
        const cacheKey = `path:${path}:${decrypt}`;

        if (this.cache.has(cacheKey)) {
            return this.cache.get(cacheKey);
        }

        const fullPath = `${this.basePath}/${path}`;
        const parameters = {};

        try {
            let nextToken = null;

            do {
                const command = new GetParametersByPathCommand({
                    Path: fullPath,
                    Recursive: true,
                    WithDecryption: decrypt,
                    NextToken: nextToken
                });

                const response = await ssmClient.send(command);

                for (const param of response.Parameters) {
                    // Remove the base path to get just the key
                    const key = param.Name.replace(`${this.basePath}/`, '');
                    parameters[key] = param.Value;
                }

                nextToken = response.NextToken;
            } while (nextToken);

            this.cache.set(cacheKey, parameters);
            return parameters;
        } catch (error) {
            throw new Error(`Error loading parameters from ${fullPath}: ${error.message}`);
        }
    }

    /**
     * Get database configuration as an object
     * @returns {Promise<Object>} Database configuration
     */
    async getDatabaseConfig() {
        const dbParams = await this.getParametersByPath('database', true);

        return {
            host: dbParams['database/host'],
            port: parseInt(dbParams['database/port'] || '5432', 10),
            database: dbParams['database/name'],
            password: dbParams['database/password']
        };
    }

    /**
     * Get API configuration as an object
     * @returns {Promise<Object>} API configuration
     */
    async getApiConfig() {
        const apiParams = await this.getParametersByPath('api', false);

        return {
            baseUrl: apiParams['api/base_url'],
            rateLimit: parseInt(apiParams['api/rate_limit'] || '1000', 10)
        };
    }
}

// Example Lambda handler
exports.handler = async (event, context) => {
    const config = new ConfigLoader();

    // Load database config
    const dbConfig = await config.getDatabaseConfig();
    console.log(`Connecting to database: ${dbConfig.host}`);

    // Load API config
    const apiConfig = await config.getApiConfig();
    console.log(`API base URL: ${apiConfig.baseUrl}`);

    // Get individual parameter
    const analyticsEnabled = await config.getParameter('features/enable_analytics');
    console.log(`Analytics enabled: ${analyticsEnabled}`);

    return {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Configuration loaded successfully',
            environment: config.environment
        })
    };
};
