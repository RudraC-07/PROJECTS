import { getUserSession } from "@/lib/auth";
import { ExpenseForm } from "@/components/ExpenseForm";
import { prisma } from "@/lib/prisma";
import { redirect } from "next/navigation";
export default async function AdminAddExpensePage() {
  const auth = await getUserSession();
  if (!auth) redirect("/login");
  if (auth.role !== "admin") redirect("/user/dashboard");
  const peoples = await prisma.peoples.findMany({
    where: { userid: auth.id },
    orderBy: { peoplename: 'asc' }
  });
  return (
    <div className="">
      <ExpenseForm role="admin" peoples={peoples} />
    </div>
  );
}