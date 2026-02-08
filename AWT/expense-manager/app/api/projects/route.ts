import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { cookies } from 'next/headers';

export async function GET() {
  try {
    const cookieStore = await cookies();
    const token = cookieStore.get('auth_token');

    if (!token) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }

    const auth = JSON.parse(token.value);
    
    // In this schema, projects are linked to a userid (Admin)
    const userId = auth.role === 'admin' ? auth.id : await (async () => {
      const p = await prisma.peoples.findUnique({ where: { peopleid: auth.id } });
      return p?.userid;
    })();

    if (!userId) {
      return NextResponse.json({ message: 'User context not found' }, { status: 404 });
    }

    const projects = await prisma.projects.findMany({
      where: { 
        userid: userId,
        isactive: true
      },
      orderBy: { projectname: 'asc' }
    });

    return NextResponse.json(projects);
  } catch (error) {
    console.error('Fetch projects error:', error);
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}

export async function POST(request: Request) {
  try {
    const cookieStore = await cookies();
    const token = cookieStore.get('auth_token');

    if (!token) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }

    const auth = JSON.parse(token.value);
    if (auth.role !== 'admin') {
      return NextResponse.json({ message: 'Forbidden' }, { status: 403 });
    }

    const body = await request.json();
    const { projectName, projectDetail, description, startDate, endDate } = body;

    if (!projectName) {
      return NextResponse.json({ message: 'Project Name is required' }, { status: 400 });
    }

    const newProject = await prisma.projects.create({
      data: {
        projectname: projectName,
        projectdetail: projectDetail || '',
        description: description || '',
        projectstartdate: startDate ? new Date(startDate) : null,
        projectenddate: endDate ? new Date(endDate) : null,
        userid: auth.id,
        isactive: true,
        created: new Date(),
        modified: new Date(),
      }
    });

    return NextResponse.json(newProject);
  } catch (error) {
    console.error('Create project error:', error);
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}
