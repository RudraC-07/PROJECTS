import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { email, password, userType } = body;

    if (!email || !password) {
      return NextResponse.json(
        { message: 'Email and password are required' },
        { status: 400 }
      );
    }

    let user = null;
    let redirectUrl = '';

    if (userType === 'admin') {
      // Check in users table
      user = await prisma.users.findFirst({
        where: {
          emailaddress: email, // Note: schema says emailaddress for users
          password: password,   // Plain text comparison as per simple requirements
        },
      });
      redirectUrl = '/admin/dashboard';
    } else {
      // Check in peoples table
      user = await prisma.peoples.findFirst({
        where: {
          email: email,      // Note: schema says email for peoples
          password: password, 
          isactive: true,    // Ensure active
        },
      });
      redirectUrl = '/user/dashboard';
    }

    if (!user) {
      return NextResponse.json(
        { message: 'Invalid credentials' },
        { status: 401 }
      );
    }

    // Login successful
    // In a real app, we would set a session/cookie here. 
    // For this UI-focused phase, we return success and let frontend redirect.
    return NextResponse.json({
      message: 'Login successful',
      user: {
        id: userType === 'admin' ? (user as any).userid : (user as any).peopleid,
        name: userType === 'admin' ? (user as any).username : (user as any).peoplename,
        role: userType
      },
      redirectUrl
    });

  } catch (error) {
    console.error('Login error:', error);
    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}
