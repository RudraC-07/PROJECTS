import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { cookies } from 'next/headers';

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { email, password, userType } = body;

    // Default to 'user' if not specified, but we will try both if needed or stick to strict checking
    // The UI should ideally send the type. 
    // We will improve logic:
    // If userType is 'admin', check Admin.
    // If userType is 'user', check User.
    // If undefined, try Admin first, then User.

    if (!email || !password) {
      return NextResponse.json(
        { message: 'Email/Username and password are required' },
        { status: 400 }
      );
    }

    let user = null;
    let role = '';
    let redirectUrl = '';
    let dbUser = null;

    // Helper to find admin
    const findAdmin = async () => {
       // Check by email OR username for flexibility
       return await prisma.users.findFirst({
        where: {
          OR: [
            { emailaddress: email },
            { username: email }
          ],
          password: password,
        },
      });
    };

    // Helper to find user
    const findNormalUser = async () => {
       return await prisma.peoples.findFirst({
        where: {
          OR: [
             { email: email },
             { peoplecode: email } // Assuming peoplecode might be used as username
          ],
          password: password,
          isactive: true,
        },
      });
    };

    if (userType === 'admin') {
      dbUser = await findAdmin();
      if (dbUser) {
        role = 'admin';
        redirectUrl = '/admin/dashboard';
      }
    } else if (userType === 'user') {
      dbUser = await findNormalUser();
      if (dbUser) {
        role = 'user';
        redirectUrl = '/user/dashboard';
      }
    } else {
      // Try Admin first
      dbUser = await findAdmin();
      if (dbUser) {
        role = 'admin';
        redirectUrl = '/admin/dashboard';
      } else {
        // Try User
        dbUser = await findNormalUser();
        if (dbUser) {
          role = 'user';
          redirectUrl = '/user/dashboard';
        }
      }
    }

    if (!dbUser) {
      return NextResponse.json(
        { message: 'Login failed' },
        { status: 401 }
      );
    }

    // Set Cookie
    const cookieStore = await cookies();
    const userId = role === 'admin' ? (dbUser as any).userid : (dbUser as any).peopleid;
    const userName = role === 'admin' ? (dbUser as any).username : (dbUser as any).peoplename;

    // Simple JSON cookie for demo purposes. 
    // In production, use a signed JWT or session ID.
    const authData = JSON.stringify({ id: userId, role, name: userName });
    
    cookieStore.set('auth_token', authData, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      path: '/',
      maxAge: 60 * 60 * 24 * 7 // 1 week
    });

    return NextResponse.json({
      message: 'Login successful',
      user: {
        id: userId,
        name: userName,
        role: role
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