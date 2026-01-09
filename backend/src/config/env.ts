import dotenv from 'dotenv';

dotenv.config();

const requiredVars = [
  'SUPABASE_URL',
  'SUPABASE_SERVICE_ROLE_KEY',
  'CLOUDINARY_CLOUD_NAME',
  'CLOUDINARY_API_KEY',
  'CLOUDINARY_API_SECRET',
  'FIREBASE_PROJECT_ID',
  'FIREBASE_PRIVATE_KEY_ID',
  'FIREBASE_PRIVATE_KEY',
  'FIREBASE_CLIENT_EMAIL',
  'FIREBASE_CLIENT_ID',
  'FIREBASE_CLIENT_X509_CERT_URL',
] as const;

type RequiredVar = (typeof requiredVars)[number];

type EnvConfig = {
  nodeEnv: string;
  port: number;
  supabaseUrl: string;
  supabaseServiceRoleKey: string;
  cloudinaryCloudName: string;
  cloudinaryApiKey: string;
  cloudinaryApiSecret: string;
  firebaseProjectId: string;
  firebasePrivateKeyId: string;
  firebasePrivateKey: string;
  firebaseClientEmail: string;
  firebaseClientId: string;
  firebaseClientX509CertUrl: string;
};

const missingKeys = requiredVars.filter((key) => !process.env[key]);

if (missingKeys.length) {
  throw new Error(
    `Missing required environment variables: ${missingKeys.join(', ')}`
  );
}

const env: EnvConfig = {
  nodeEnv: process.env.NODE_ENV ?? 'development',
  port: Number(process.env.PORT ?? 5000),
  supabaseUrl: process.env.SUPABASE_URL as string,
  supabaseServiceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY as string,
  cloudinaryCloudName: process.env.CLOUDINARY_CLOUD_NAME as string,
  cloudinaryApiKey: process.env.CLOUDINARY_API_KEY as string,
  cloudinaryApiSecret: process.env.CLOUDINARY_API_SECRET as string,
  firebaseProjectId: process.env.FIREBASE_PROJECT_ID as string,
  firebasePrivateKeyId: process.env.FIREBASE_PRIVATE_KEY_ID as string,
  firebasePrivateKey: process.env.FIREBASE_PRIVATE_KEY as string,
  firebaseClientEmail: process.env.FIREBASE_CLIENT_EMAIL as string,
  firebaseClientId: process.env.FIREBASE_CLIENT_ID as string,
  firebaseClientX509CertUrl: process.env.FIREBASE_CLIENT_X509_CERT_URL as string,
};

export default env;
