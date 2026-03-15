import { getUserSession } from "@/lib/auth";
import { IncomeForm } from "@/components/IncomeForm";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";
export default async function AdminAddIncomePage() {
  const auth = await getUserSession();
  if (!auth) redirect("/login");
  if (auth.role !== "admin") redirect("/user/dashboard");
  return (
    <div className="">
      {" "}
      <IncomeForm role="admin" />{" "}
    </div>
  );
}