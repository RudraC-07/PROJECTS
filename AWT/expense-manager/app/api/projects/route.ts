import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { getUserSession } from '@/lib/auth';
export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const id = searchParams.get('id');
    const auth = await getUserSession();
    if (!auth) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
    if (id) {
      const project = await prisma.projects.findUnique({
        where: { projectid: parseInt(id) }
      });
      if (!project) return NextResponse.json({ message: 'Project not found' }, { status: 404 });
      return NextResponse.json(project);
    }
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
    const auth = await getUserSession();
    if (!auth) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
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
export async function DELETE(request: Request) {
  try {
    const auth = await getUserSession();
    if (!auth) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
    if (auth.role !== 'admin') {
      return NextResponse.json({ message: 'Forbidden' }, { status: 403 });
    }
    const { searchParams } = new URL(request.url);
    const id = searchParams.get('id');
    if (!id) {
      return NextResponse.json({ message: 'Project ID is required' }, { status: 400 });
    }
    const project = await prisma.projects.findUnique({
      where: { projectid: parseInt(id) }
    });
    if (!project || project.userid !== auth.id) {
      return NextResponse.json({ message: 'Project not found or unauthorized' }, { status: 404 });
    }
    await prisma.expenses.deleteMany({ where: { projectid: parseInt(id) } });
    await prisma.incomes.deleteMany({ where: { projectid: parseInt(id) } });
    await prisma.projects.delete({
      where: { projectid: parseInt(id) }
    });
    return NextResponse.json({ message: 'Project deleted successfully' });
  } catch (error) {
    console.error('Delete project error:', error);
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}