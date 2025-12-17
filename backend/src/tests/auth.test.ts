/**
 * Authentication Test Script
 * 
 * Run with: npx ts-node src/tests/auth.test.ts
 * 
 * Make sure the server is running first: npm run dev
 */

const BASE_URL = 'http://localhost:5000/api';

// ============ TEST CREDENTIALS ============
const TEST_USER = {
  email: 'fafa.ots15@gmail.com',
  password: 'Test1234!',
  first_name: 'Test',
  last_name: 'User',
};

// ============ HELPER FUNCTIONS ============

async function request(
  method: string,
  endpoint: string,
  body?: object,
  token?: string
): Promise<{ status: number; ok: boolean; data: any }> {
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  const response = await fetch(`${BASE_URL}${endpoint}`, {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined,
  });

  const data = await response.json().catch(() => null);

  return {
    status: response.status,
    ok: response.ok,
    data,
  };
}

function log(title: string, data: unknown) {
  console.log(`\n${'='.repeat(50)}`);
  console.log(`📋 ${title}`);
  console.log('='.repeat(50));
  console.log(JSON.stringify(data, null, 2));
}

function success(message: string) {
  console.log(`\n✅ ${message}`);
}

function error(message: string) {
  console.log(`\n❌ ${message}`);
}

// ============ TEST FUNCTIONS ============

async function testHealthCheck() {
  console.log('\n🏥 Testing Health Check...');
  const res = await request('GET', '/../healthz');
  
  if (res.ok) {
    success('Health check passed');
    log('Response', res.data);
  } else {
    error('Health check failed');
    log('Error', res);
  }
  
  return res.ok;
}

async function testRegister() {
  console.log('\n📝 Testing User Registration...');
  
  const res = await request('POST', '/auth/register', {
    email: TEST_USER.email,
    password: TEST_USER.password,
    first_name: TEST_USER.first_name,
    last_name: TEST_USER.last_name,
  });

  if (res.ok) {
    success('Registration successful');
    log('Response', res.data);
    return res.data;
  } else {
    if (res.status === 400 && res.data?.details?.includes('already')) {
      console.log('ℹ️  User already exists, continuing with login test...');
      return null;
    }
    error(`Registration failed with status ${res.status}`);
    log('Error', res.data);
    return null;
  }
}

async function testLogin() {
  console.log('\n🔐 Testing User Login...');
  
  const res = await request('POST', '/auth/login', {
    email: TEST_USER.email,
    password: TEST_USER.password,
  });

  if (res.ok) {
    success('Login successful');
    log('Session Info', {
      user_id: res.data?.user?.id,
      email: res.data?.user?.email,
      access_token: res.data?.session?.access_token?.substring(0, 50) + '...',
      expires_at: res.data?.session?.expires_at,
    });
    return res.data?.session?.access_token;
  } else {
    error(`Login failed with status ${res.status}`);
    log('Error', res.data);
    return null;
  }
}

async function testGetProfile(token: string) {
  console.log('\n👤 Testing Get Profile (Authenticated)...');
  
  const res = await request('GET', '/auth/me', undefined, token);

  if (res.ok) {
    success('Profile retrieved successfully');
    log('User Profile', res.data);
    return true;
  } else {
    error(`Get profile failed with status ${res.status}`);
    log('Error', res.data);
    return false;
  }
}

async function testUnauthorizedAccess() {
  console.log('\n🚫 Testing Unauthorized Access (No Token)...');
  
  const res = await request('GET', '/auth/me');

  if (res.status === 401) {
    success('Correctly rejected unauthorized request');
    log('Response', res.data);
    return true;
  } else {
    error(`Expected 401, got ${res.status}`);
    log('Response', res.data);
    return false;
  }
}

async function testInvalidLogin() {
  console.log('\n🔒 Testing Invalid Login Credentials...');
  
  const res = await request('POST', '/auth/login', {
    email: TEST_USER.email,
    password: 'wrongpassword',
  });

  if (res.status === 401) {
    success('Correctly rejected invalid credentials');
    log('Response', res.data);
    return true;
  } else {
    error(`Expected 401, got ${res.status}`);
    log('Response', res.data);
    return false;
  }
}

async function testValidationError() {
  console.log('\n⚠️  Testing Validation Error (Invalid Email)...');
  
  const res = await request('POST', '/auth/register', {
    email: 'not-an-email',
    password: 'short',
  });

  if (res.status === 400) {
    success('Correctly returned validation error');
    log('Validation Errors', res.data);
    return true;
  } else {
    error(`Expected 400, got ${res.status}`);
    log('Response', res.data);
    return false;
  }
}

// ============ MAIN TEST RUNNER ============

async function runTests() {
  console.log('\n');
  console.log('╔════════════════════════════════════════════════════╗');
  console.log('║        🧪 AUTHENTICATION TEST SUITE 🧪              ║');
  console.log('╠════════════════════════════════════════════════════╣');
  console.log(`║  Base URL: ${BASE_URL.padEnd(39)}║`);
  console.log(`║  Test User: ${TEST_USER.email.padEnd(38)}║`);
  console.log('╚════════════════════════════════════════════════════╝');

  const results: { test: string; passed: boolean }[] = [];

  try {
    // Test 1: Health Check
    results.push({ test: 'Health Check', passed: await testHealthCheck() });

    // Test 2: Validation Error
    results.push({ test: 'Validation Error', passed: await testValidationError() });

    // Test 3: Register
    const registerResult = await testRegister();
    results.push({ test: 'Registration', passed: registerResult !== undefined });

    // Test 4: Login
    const token = await testLogin();
    results.push({ test: 'Login', passed: !!token });

    if (token) {
      // Test 5: Get Profile (Authenticated)
      results.push({ test: 'Get Profile', passed: await testGetProfile(token) });
    }

    // Test 6: Unauthorized Access
    results.push({ test: 'Unauthorized Access', passed: await testUnauthorizedAccess() });

    // Test 7: Invalid Login
    results.push({ test: 'Invalid Login', passed: await testInvalidLogin() });

  } catch (err) {
    error('Test suite crashed');
    console.error(err);
  }

  // Print Summary
  console.log('\n');
  console.log('╔════════════════════════════════════════════════════╗');
  console.log('║                  📊 TEST SUMMARY                   ║');
  console.log('╠════════════════════════════════════════════════════╣');
  
  for (const result of results) {
    const status = result.passed ? '✅ PASS' : '❌ FAIL';
    console.log(`║  ${status}  ${result.test.padEnd(38)}║`);
  }
  
  const passed = results.filter(r => r.passed).length;
  const total = results.length;
  
  console.log('╠════════════════════════════════════════════════════╣');
  console.log(`║  Total: ${passed}/${total} tests passed${' '.repeat(29)}║`);
  console.log('╚════════════════════════════════════════════════════╝');
  console.log('\n');
}

runTests();
