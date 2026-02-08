import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { cookies } from 'next/headers';

export async function POST(request: Request) {
  try {
    const cookieStore = await cookies();
    const token = cookieStore.get('auth_token');

    if (!token) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }

    const admin = JSON.parse(token.value);
    if (admin.role !== 'admin') {
      return NextResponse.json({ message: 'Forbidden' }, { status: 403 });
    }

    const body = await request.json();
    const { name, email, password, mobile, description } = body;

    if (!name || !email || !password) {
      return NextResponse.json(
        { message: 'Name, email, and password are required' },
        { status: 400 }
      );
    }

    // Create the "People" (User)
    const newPerson = await prisma.peoples.create({
      data: {
        peoplename: name,
        email: email,
        password: password, // Plain text as per project pattern
        mobileno: mobile || '',
        description: description || '',
        userid: admin.id,
        isactive: true,
        peoplecode: email.split('@')[0], // Simple default code
        created: new Date(),
        modified: new Date(),
      },
    });

    return NextResponse.json({
      message: 'User created successfully',
      user: newPerson,
    });

  } catch (error) {
    console.error('Create person error:', error);
    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function GET() {
  try {
    const cookieStore = await cookies();
    const token = cookieStore.get('auth_token');

    if (!token) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }

    const admin = JSON.parse(token.value);
    
    const peoples = await prisma.peoples.findMany({
      where: { userid: admin.id },
      orderBy: { created: 'desc' }
    });

    return NextResponse.json(peoples);
  } catch (error) {
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}
