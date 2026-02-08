import { ExpenseForm } from "@/components/ExpenseForm";
import { prisma } from "@/lib/prisma";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";

export default async function AdminAddExpensePage() {
  const cookieStore = await cookies();
  const token = cookieStore.get('auth_token');

  if (!token) redirect('/login');
  const auth = JSON.parse(token.value);
  if (auth.role !== 'admin') redirect('/user/dashboard');

  // Fetch peoples for the selection
  const peoples = await prisma.peoples.findMany({
    where: { userid: auth.id },
    orderBy: { peoplename: 'asc' }
  });

  return (
    <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
      <ExpenseForm role="admin" peoples={peoples} />
    </div>
  );
}
