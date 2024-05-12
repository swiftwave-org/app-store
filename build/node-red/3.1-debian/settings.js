const bcrypt = require('bcrypt');

const adminUsername = process.env.ADMIN_USERNAME;
const adminPassword = process.env.ADMIN_PASSWORD;

if (!adminUsername || !adminPassword) {
    throw new Error("ADMIN_USERNAME and ADMIN_PASSWORD environment variables must be set.");
}

const hashedPassword = bcrypt.hashSync(adminPassword, 10);

module.exports = {
    flowFile: "flows.json",
    flowFilePretty: true,
    adminAuth: {
        "type": "credentials",
        "users": [
            {
                "username": adminUsername,
                "password": hashedPassword,
                "permissions": "*"
            }
        ]
    },
    uiPort: process.env.PORT || 1880,
    httpNodeCors: {
        origin: "*",
        methods: "HEAD,GET,PUT,POST,DELETE"
    },
    logging: {
        console: {

            level: "info",
            metrics: false,
            audit: false
        }
    },
    exportGlobalContextKeys: false,
    externalModules: {},
    editorTheme: {
        palette: {},
        projects: {
            enabled: true,
            workflow: {
                mode: "auto"
            }
        },
        codeEditor: {
            lib: "monaco",
            options: {
            }
        }
    },
    functionExternalModules: true,
    functionTimeout: 0,
    functionGlobalContext: {
    },
    debugMaxLength: 1000,
    mqttReconnectTime: 15000,
    serialReconnectTime: 15000,
}