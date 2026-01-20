import Link from 'next/link';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Card } from '@/components/ui/Card';

export default function RegisterPage() {
  return (
    <>
      <div className="sm:mx-auto sm:w-full sm:max-w-md mb-6 text-center">
        <h2 className="text-3xl font-bold tracking-tight text-foreground">Create a new account</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          Already have an account?{' '}
          <Link href="/login" className="font-medium text-primary hover:text-primary/80">
            Sign in
          </Link>
        </p>
      </div>

      <Card>
        <form className="space-y-6" action="#" method="POST">
          <Input 
            label="Full Name" 
            id="name" 
            name="name" 
            type="text" 
            autoComplete="name" 
            required 
            placeholder="John Doe"
          />

          <Input 
            label="Email address" 
            id="email" 
            name="email" 
            type="email" 
            autoComplete="email" 
            required 
            placeholder="you@example.com"
          />

           <Input 
            label="Mobile Number" 
            id="mobile" 
            name="mobile" 
            type="tel" 
            autoComplete="tel" 
            required 
            placeholder="+1 (555) 000-0000"
          />

          <Input 
            label="Password" 
            id="password" 
            name="password" 
            type="password" 
            autoComplete="new-password" 
            required 
          />
          
          <Input 
            label="Confirm Password" 
            id="confirmPassword" 
            name="confirmPassword" 
            type="password" 
            autoComplete="new-password" 
            required 
          />

          <div>
            <Button type="submit" fullWidth>
              Create Account
            </Button>
          </div>
        </form>
      </Card>
    </>
  );
}
