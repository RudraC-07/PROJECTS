import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { getUserSession } from '@/lib/auth';
export async function POST(request: Request) {
  try {
    const auth = await getUserSession();
    if (!auth) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
    const body = await request.json();
    const { amount, categoryId, subCategoryId, projectId, date, detail, description, peopleId } = body;
    if (!amount || !date) {
      return NextResponse.json(
        { message: 'Amount and Date are required' },
        { status: 400 }
      );
    }
    let finalUserId: number;
    let finalPeopleId: number;
    if (auth.role === 'admin') {
      finalUserId = auth.id;
      finalPeopleId = peopleId ? parseInt(peopleId) : 0;
    } else {
      const person = await prisma.peoples.findUnique({ where: { peopleid: auth.id } });
      if (!person) throw new Error("Person not found");
      finalUserId = person.userid;
      finalPeopleId = auth.id;
    }
    const newIncome = await prisma.incomes.create({
      data: {
        amount: parseFloat(amount),
        incomedate: new Date(date),
        categoryid: categoryId ? parseInt(categoryId) : null,
        subcategoryid: subCategoryId ? parseInt(subCategoryId) : null,
        projectid: projectId ? parseInt(projectId) : null,
        incomedetail: detail || '',
        description: description || '',
        peopleid: finalPeopleId,
        userid: finalUserId,
        created: new Date(),
        modified: new Date(),
      },
    });
    return NextResponse.json({
      message: 'Income added successfully',
      income: newIncome,
    });
  } catch (error) {
    console.error('Add income error:', error);
    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}
export async function GET(request: Request) {
  try {
    const auth = await getUserSession();
    if (!auth) return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    const { searchParams } = new URL(request.url);
    const projectId = searchParams.get('projectId');
    let where: any = {};
    if (auth.role === 'admin') {
      where.userid = auth.id;
    } else {
      where.peopleid = auth.id;
    }
    if (projectId) {
      where.projectid = parseInt(projectId);
    }
    const incomes = await prisma.incomes.findMany({
      where,
      include: {
        categories: true,
        projects: true
      },
      orderBy: { incomedate: 'desc' }
    });
    return NextResponse.json(incomes);
  } catch (error) {
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}
export async function DELETE(request: Request) {
  try {
    const auth = await getUserSession();
    if (!auth) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
    const { searchParams } = new URL(request.url);
    const id = searchParams.get('id');
    if (!id) {
      return NextResponse.json({ message: 'Income ID is required' }, { status: 400 });
    }
    const income = await prisma.incomes.findUnique({
      where: { incomeid: parseInt(id) }
    });
    if (!income) {
      return NextResponse.json({ message: 'Income not found' }, { status: 404 });
    }
    if (auth.role === 'admin') {
      if (income.userid !== auth.id) {
        return NextResponse.json({ message: 'Forbidden' }, { status: 403 });
      }
    } else {
      if (income.peopleid !== auth.id) {
        return NextResponse.json({ message: 'Forbidden' }, { status: 403 });
      }
    }
    await prisma.incomes.delete({
      where: { incomeid: parseInt(id) }
    });
    return NextResponse.json({ message: 'Income deleted successfully' });
  } catch (error) {
    console.error('Delete income error:', error);
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}