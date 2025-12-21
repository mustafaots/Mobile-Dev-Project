import os from 'os';
import app from './app';
import env from './config/env';

// Get local IP address
const getLocalIP = (): string => {
  const interfaces = os.networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name] || []) {
      // Skip internal (loopback) and non-IPv4 addresses
      if (iface.family === 'IPv4' && !iface.internal) {
        return iface.address;
      }
    }
  }
  return 'localhost';
};

const start = async () => {
  try {
    const host = '0.0.0.0'; // Listen on all interfaces
    app.listen(env.port, host, () => {
      const localIP = getLocalIP();
      console.info(`\n🚀 API server is running!\n`);
      console.info(`   Local:   http://localhost:${env.port}`);
      console.info(`   Network: http://${localIP}:${env.port}`);
      console.info(`\n   API Base: http://${localIP}:${env.port}/api\n`);
    });
  } catch (error) {
    console.error('Unable to start server', error);
    process.exit(1);
  }
};

start();
