import { getUserSession } from "@/lib/auth";
import { ExpenseForm } from "@/components/ExpenseForm";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";
export default async function UserAddExpensePage() {
  const auth = await getUserSession();
  if (!auth) redirect("/login");
  return (
    <div className="">
      {" "}
      <ExpenseForm role="user" />{" "}
    </div>
  );
}