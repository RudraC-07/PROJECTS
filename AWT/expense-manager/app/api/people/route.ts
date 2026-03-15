import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { getUserSession } from '@/lib/auth';
import bcrypt from 'bcryptjs';
export async function POST(request: Request) {
  try {
    const admin = await getUserSession();
    if (!admin) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
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
    const hashedPassword = await bcrypt.hash(password, 10);
    const newPerson = await prisma.peoples.create({
      data: {
        peoplename: name,
        email: email,
        password: hashedPassword,
        mobileno: mobile || '',
        description: description || '',
        userid: admin.id,
        isactive: true,
        peoplecode: email.split('@')[0],
        created: new Date(),
        modified: new Date(),
      },
    });
    return NextResponse.json({
      message: 'User created successfully',
      user: { ...newPerson, password: undefined },
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
    const admin = await getUserSession();
    if (!admin) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
    const peoples = await prisma.peoples.findMany({
      where: { userid: admin.id },
      orderBy: { created: 'desc' }
    });
    return NextResponse.json(peoples);
  } catch (error) {
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}
export async function DELETE(request: Request) {
  try {
    const admin = await getUserSession();
    if (!admin || admin.role !== 'admin') {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
    const { searchParams } = new URL(request.url);
    const id = searchParams.get('id');
    if (!id) {
      return NextResponse.json({ message: 'People ID is required' }, { status: 400 });
    }
    const person = await prisma.peoples.findUnique({
      where: { peopleid: parseInt(id) }
    });
    if (!person || person.userid !== admin.id) {
      return NextResponse.json({ message: 'Person not found or unauthorized' }, { status: 404 });
    }
    await prisma.expenses.deleteMany({ where: { peopleid: parseInt(id) } });
    await prisma.incomes.deleteMany({ where: { peopleid: parseInt(id) } });
    await prisma.peoples.delete({
      where: { peopleid: parseInt(id) }
    });
    return NextResponse.json({ message: 'Person deleted successfully' });
  } catch (error) {
    console.error('Delete person error:', error);
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}