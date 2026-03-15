import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { cookies } from 'next/headers';
import bcrypt from 'bcryptjs';
import { signToken } from '@/lib/auth';
export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { email, password, userType } = body;
    if (!email || !password) {
      return NextResponse.json(
        { message: 'Email/Username and password are required' },
        { status: 400 }
      );
    }
    const normalizedEmail = email.trim().replace(/\s+/g, ' ');
    let role = '';
    let redirectUrl = '';
    let dbUser = null;
    const findAdmin = async () => {
      const user = await prisma.users.findFirst({
        where: {
          OR: [
            { emailaddress: { equals: normalizedEmail, mode: 'insensitive' } },
            { username: { equals: normalizedEmail, mode: 'insensitive' } },
          ],
        },
      });
      if (user) {
        const plainMatch = user.password === password;
        let bcryptMatch = false;
        try { bcryptMatch = await bcrypt.compare(password, user.password); } catch {}
        if (plainMatch || bcryptMatch) return user;
      }
      return null;
    };
    const findNormalUser = async () => {
      const user = await prisma.peoples.findFirst({
        where: {
          OR: [
            { email: { equals: normalizedEmail, mode: 'insensitive' } },
            { peoplecode: { equals: normalizedEmail, mode: 'insensitive' } },
            { peoplename: { equals: normalizedEmail, mode: 'insensitive' } },
          ],
          isactive: true,
        },
      });
      if (user) {
        const plainMatch = user.password === password;
        let bcryptMatch = false;
        try { bcryptMatch = await bcrypt.compare(password, user.password); } catch {}
        if (plainMatch || bcryptMatch) return user;
      }
      return null;
    };
    if (userType === 'admin') {
      dbUser = await findAdmin();
      if (dbUser) { role = 'admin'; redirectUrl = '/admin/dashboard'; }
    } else if (userType === 'user') {
      dbUser = await findNormalUser();
      if (dbUser) { role = 'user'; redirectUrl = '/user/dashboard'; }
    } else {
      dbUser = await findAdmin();
      if (dbUser) {
        role = 'admin';
        redirectUrl = '/admin/dashboard';
      } else {
        dbUser = await findNormalUser();
        if (dbUser) { role = 'user'; redirectUrl = '/user/dashboard'; }
      }
    }
    if (!dbUser) {
      return NextResponse.json({ message: 'Login failed' }, { status: 401 });
    }
    const cookieStore = await cookies();
    const userId = role === 'admin' ? (dbUser as any).userid : (dbUser as any).peopleid;
    const userName = role === 'admin' ? (dbUser as any).username : (dbUser as any).peoplename;
    const token = await signToken({ id: Number(userId), role, name: userName });
    cookieStore.set('auth_token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      path: '/',
      maxAge: 60 * 60 * 24 * 7,
    });
    return NextResponse.json({
      message: 'Login successful',
      user: { id: userId, name: userName, role },
      redirectUrl,
    });
  } catch (error) {
    console.error('Login error:', error);
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}