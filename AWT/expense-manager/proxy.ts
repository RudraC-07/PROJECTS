import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { jwtVerify } from 'jose';
const JWT_SECRET = process.env.JWT_SECRET || 'your-super-secret-jwt-key-change-in-prod';
const key = new TextEncoder().encode(JWT_SECRET);
export async function proxy(request: NextRequest) {
  const token = request.cookies.get('auth_token')?.value;
  const { pathname } = request.nextUrl;
  const isAuthRoute = pathname.startsWith('/login') || pathname.startsWith('/register') || pathname === '/';
  if (pathname.startsWith('/api/auth') || pathname.includes('/_next') || pathname.includes('/favicon.ico')) {
    return NextResponse.next();
  }
  if (!token) {
    if (!isAuthRoute && !pathname.startsWith('/api')) {
      return NextResponse.redirect(new URL('/login', request.url));
    }
    if (pathname.startsWith('/api')) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
    return NextResponse.next();
  }
  let payload;
  try {
    const verified = await jwtVerify(token, key, { algorithms: ['HS256'] });
    payload = verified.payload as { role: string };
  } catch (e) {
    if (!isAuthRoute && !pathname.startsWith('/api')) {
      const res = NextResponse.redirect(new URL('/login', request.url));
      res.cookies.delete('auth_token');
      return res;
    }
    if (pathname.startsWith('/api')) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
    return NextResponse.next();
  }
  if (payload.role === 'admin' && pathname.startsWith('/user')) {
    return NextResponse.redirect(new URL('/admin/dashboard', request.url));
  }
  if (payload.role === 'user' && pathname.startsWith('/admin')) {
    return NextResponse.redirect(new URL('/user/dashboard', request.url));
  }
  if (isAuthRoute && pathname !== '/') {
    return NextResponse.redirect(new URL(`/${payload.role}/dashboard`, request.url));
  }
  return NextResponse.next();
}
export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico).*)'],
};