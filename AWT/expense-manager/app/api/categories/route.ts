import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { cookies } from 'next/headers';

export async function GET(request: Request) {
  try {
    const cookieStore = await cookies();
    const token = cookieStore.get('auth_token');

    if (!token) {
      return NextResponse.json({ message: 'Unauthorized' }, { status: 401 });
    }

    const auth = JSON.parse(token.value);
    const { searchParams } = new URL(request.url);
    const type = searchParams.get('type') || 'expense'; // 'expense' or 'income'
    
    const userId = auth.role === 'admin' ? auth.id : await (async () => {
      const p = await prisma.peoples.findUnique({ where: { peopleid: auth.id } });
      return p?.userid;
    })();

    if (!userId) {
      return NextResponse.json({ message: 'User context not found' }, { status: 404 });
    }

    const categories = await prisma.categories.findMany({
      where: { 
        userid: userId,
        isexpense: type === 'expense',
        isincome: type === 'income',
        isactive: true
      },
      include: {
        sub_categories: {
          where: { isactive: true },
          orderBy: { subcategoryname: 'asc' }
        }
      },
      orderBy: { categoryname: 'asc' }
    });

    // Auto-seed Categories AND Subcategories if none exist
    const totalCount = await prisma.categories.count({ where: { userid: userId } });
    if (totalCount === 0) {
      const seedData = [
        // Expenses
        { 
          name: 'Equipment & Hardware', 
          isexpense: true,
          subs: ['Computers/Laptops', 'Networking Gear', 'Office Furniture', 'Specialized Machinery'] 
        },
        { 
          name: 'Software & Licenses', 
          isexpense: true,
          subs: ['SaaS Subscriptions', 'Development Tools', 'Security Software', 'Cloud Infrastructure'] 
        },
        { 
          name: 'Professional Services', 
          isexpense: true,
          subs: ['Legal Fees', 'Consultancy', 'Accounting', 'Audits'] 
        },
        { 
          name: 'Labor & Subcontracting', 
          isexpense: true,
          subs: ['Contractor Fees', 'Overtime Pay', 'Freelance Services', 'Training'] 
        },
        { 
          name: 'Travel & Accommodation', 
          isexpense: true,
          subs: ['Airfare', 'Hotel Stays', 'Meals & Incidentals', 'Local Transport'] 
        },
        // Incomes
        {
          name: 'Project Funding',
          isexpense: false,
          subs: ['Grant Money', 'Internal Budget', 'Investor Money']
        },
        {
          name: 'Client Payments',
          isexpense: false,
          subs: ['Service Fees', 'Milestone Payment', 'Retainer']
        }
      ];

      for (const item of seedData) {
        const newCat = await prisma.categories.create({
          data: {
            categoryname: item.name,
            isexpense: item.isexpense,
            isincome: !item.isexpense,
            isactive: true,
            userid: userId,
            created: new Date(),
            modified: new Date(),
          }
        });

        await Promise.all(
          item.subs.map(subName => 
            prisma.sub_categories.create({
              data: {
                subcategoryname: subName,
                categoryid: newCat.categoryid,
                isexpense: item.isexpense,
                isincome: !item.isexpense,
                isactive: true,
                userid: userId,
                created: new Date(),
                modified: new Date(),
              }
            })
          )
        );
      }

      // Re-fetch filtered
      return NextResponse.json(await prisma.categories.findMany({
        where: { 
          userid: userId, 
          isexpense: type === 'expense',
          isincome: type === 'income'
        },
        include: { sub_categories: true },
        orderBy: { categoryname: 'asc' }
      }));
    }

    return NextResponse.json(categories);
  } catch (error) {
    console.error('Fetch categories error:', error);
    return NextResponse.json({ message: 'Internal server error' }, { status: 500 });
  }
}
