import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import bcrypt from 'bcryptjs';
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
    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await prisma.users.create({
      data: {
        username: name,
        emailaddress: email,
        password: hashedPassword,
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