import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { name, email, mobile, password } = body;

    if (!name || !email || !password) {
      return NextResponse.json(
        { message: 'Name, email, and password are required' },
        { status: 400 }
      );
    }

    // Check if user already exists
    const existingUser = await prisma.users.findUnique({
      where: {
        emailaddress: email,
      },
    });

    if (existingUser) {
      return NextResponse.json(
        { message: 'User with this email already exists' },
        { status: 409 }
      );
    }

    // Create new User
    // Note: Storing password in plain text as per existing pattern. 
    // IN PRODUCTION: USE BCRYPT OR ARGON2.
    const newUser = await prisma.users.create({
      data: {
        username: name,
        emailaddress: email,
        password: password,
        mobileno: mobile || '',
        created: new Date(),
        modified: new Date(),
      },
    });

    return NextResponse.json({
      message: 'User registered successfully',
      user: {
        id: newUser.userid,
        name: newUser.username,
        email: newUser.emailaddress,
      },
    });

  } catch (error) {
    console.error('Registration error:', error);
    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}
