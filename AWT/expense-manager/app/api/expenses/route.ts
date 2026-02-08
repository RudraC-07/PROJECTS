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

    const auth = JSON.parse(token.value);
    const body = await request.json();
    const { amount, categoryId, subCategoryId, projectId, date, detail, description, peopleId } = body;

    if (!amount || !date) {
      return NextResponse.json(
        { message: 'Amount and Date are required' },
        { status: 400 }
      );
    }

    // Determine IDs based on role
    let finalUserId: number;
    let finalPeopleId: number;

    if (auth.role === 'admin') {
      finalUserId = auth.id;
      finalPeopleId = peopleId ? parseInt(peopleId) : 0; // Admin can specify or default to 0 (themselves?)
    } else {
      // It's a "people" user
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
    const cookieStore = await cookies();
    const token = cookieStore.get('auth_token');

    if (!token) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }

    const auth = JSON.parse(token.value);

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
