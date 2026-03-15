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
    const newExpense = await prisma.expenses.create({
      data: {
        amount: parseFloat(amount),
        expensedate: new Date(date),
        categoryid: categoryId ? parseInt(categoryId) : null,
        subcategoryid: subCategoryId ? parseInt(subCategoryId) : null,
        projectid: projectId ? parseInt(projectId) : null,
        expensedetail: detail || '',
        description: description || '',
        peopleid: finalPeopleId,
        userid: finalUserId,
        created: new Date(),
        modified: new Date(),
      },
    });
    return NextResponse.json({
      message: 'Expense added successfully',
      expense: newExpense,
    });
  } catch (error) {
    console.error('Add expense error:', error);
    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}
export async function GET() {
  try {
    const auth = await getUserSession();
    if (!auth) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
    let where: any = {};
    if (auth.role === 'admin') {
      where.userid = auth.id;
    } else {
      where.peopleid = auth.id;
    }
    const expenses = await prisma.expenses.findMany({
      where,
      include: {
        categories: true,
        projects: true
      },
      orderBy: { expensedate: 'desc' }
    });
    return NextResponse.json(expenses);
  } catch (error) {
    console.error('Fetch expenses error:', error);
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
      return NextResponse.json({ message: 'Expense ID is required' }, { status: 400 });
    }
    const expense = await prisma.expenses.findUnique({
      where: { expenseid: parseInt(id) }
    });
    if (!expense) {
      return NextResponse.json({ message: 'Expense not found' }, { status: 404 });
    }
    if (auth.role === 'admin') {
      if (expense.userid !== auth.id) {
        return NextResponse.json({ message: 'Forbidden' }, { status: 403 });
      }
    } else {
      if (expense.peopleid !== auth.id) {
        return NextResponse.json({ message: 'Forbidden' }, { status: 403 });
      }
    }
    await prisma.expenses.delete({
      where: { expenseid: parseInt(id) }
    });
    return NextResponse.json({ message: 'Expense deleted successfully' });
  } catch (error) {
    console.error('Delete expense error:', error);
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}