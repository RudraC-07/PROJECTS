import { NextResponse } from 'next/server';
import { cookies } from 'next/headers';
export async function POST() {
  const cookieStore = await cookies();
  cookieStore.delete('auth_token');
  return NextResponse.json({ message: 'Logged out successfully' });
}
export async function GET() {
  const cookieStore = await cookies();
  cookieStore.delete('auth_token');
  return Response.redirect(new URL('/login', process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000'));
}