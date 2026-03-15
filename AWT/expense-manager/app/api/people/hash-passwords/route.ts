import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { getUserSession } from '@/lib/auth';
import bcrypt from 'bcryptjs';
export async function POST() {
  try {
    const session = await getUserSession();
    if (!session || session.role !== 'admin') {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }
    const peoples = await prisma.peoples.findMany();
    let hashed = 0;
    let skipped = 0;
    for (const person of peoples) {
      if (person.password.startsWith('$2b$') || person.password.startsWith('$2a$')) {
        skipped++;
        continue;
      }
      const newHash = await bcrypt.hash(person.password, 10);
      await prisma.peoples.update({
        where: { peopleid: person.peopleid },
        data: { password: newHash, modified: new Date() },
      });
      hashed++;
    }
    return NextResponse.json({ message: 'Done', hashed, skipped, total: peoples.length });
  } catch (error) {
    console.error('Hash passwords error:', error);
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}