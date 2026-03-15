'use client';
import { useState, useEffect } from 'react';
import { Card } from '@/components/ui/Card';
import { Button } from '@/components/ui/Button';
import { ConfirmModal } from '@/components/ui/ConfirmModal';
import Link from 'next/link';
import { Plus, Briefcase, Calendar, Trash2 } from 'lucide-react';
export default function ProjectsPage() {
  const [projects, setProjects] = useState([]);
  const [loading, setLoading] = useState(true);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, id: 0, name: '' });
  useEffect(() => {
    fetchProjects();
  }, []);
  const fetchProjects = async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/projects');
      const data = await res.json();
      if (res.ok) setProjects(data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };
  const handleDelete = async () => {
    const { id } = deleteModal;
    try {
      const res = await fetch(`/api/projects?id=${id}`, {
        method: 'DELETE',
      });
      if (res.ok) {
        setProjects(projects.filter((p: any) => p.projectid !== id));
      } else {
        const data = await res.json();
        alert(data.message || 'Failed to delete project');
      }
    } catch (err) {
      console.error(err);
      alert('An error occurred while deleting the project');
    }
  };
  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">Company Projects</h1>
          <p className="text-muted-foreground mt-1">Manage and track expenses for various company projects.</p>
        </div>
        <Link href="/admin/projects/add">
          <Button className="font-medium shadow-md">
            <Plus className="mr-2 h-4 w-4" /> Create New Project
          </Button>
        </Link>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {loading ? (
          <div className="col-span-full py-20 text-center">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
            <p className="text-muted-foreground">Loading projects...</p>
          </div>
        ) : projects.length > 0 ? (
          projects.map((project: any) => (
            <Card key={project.projectid} className="hover:shadow-xl border-border/50 group relative">
              <div className="flex items-start justify-between mb-4">
                <div className="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-primary-foreground">
                  <Briefcase className="h-6 w-6" />
                </div>
                <div className="flex items-center gap-2">
                  <span className="inline-flex items-center rounded-full px-2 py-1 text-[10px] font-medium bg-emerald-500/10 text-emerald-600 border border-emerald-500/20">
                    ACTIVE
                  </span>
                  <button 
                    onClick={(e) => {
                      e.preventDefault();
                      setDeleteModal({ isOpen: true, id: project.projectid, name: project.projectname });
                    }}
                    className="p-2 text-rose-500 hover:bg-rose-500/10 rounded-xl border border-transparent hover:border-rose-500/20 shadow-sm flex items-center justify-center bg-background"
                    title="Delete Project"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              </div>
              <Link href={`/admin/projects/${project.projectid}`} className="block">
                <h3 className="text-lg font-semibold text-foreground group-hover:text-primary">
                  {project.projectname}
                </h3>
                <p className="text-sm text-muted-foreground mt-2 line-clamp-2 min-h-[40px]">
                  {project.projectdetail || project.description || 'No description provided.'}
                </p>
              </Link>
              <div className="mt-6 pt-4 border-t border-border flex items-center justify-between text-xs text-muted-foreground">
                <div className="flex items-center gap-1">
                  <Calendar className="h-3.5 w-3.5" />
                  {project.projectstartdate ? new Date(project.projectstartdate).toLocaleDateString('en-GB') : 'N/A'}
                </div>
                <Link href={`/admin/projects/${project.projectid}`} className="font-medium text-primary hover:underline">
                  View Details →
                </Link>
              </div>
            </Card>
          ))
        ) : (
          <div className="col-span-full py-20 text-center border-2 border-dashed rounded-xl bg-background mt-4 shadow-inner">
            <div className="h-12 w-12 rounded-full bg-muted flex items-center justify-center mx-auto mb-4">
               <Briefcase className="h-6 w-6 text-muted-foreground" />
            </div>
            <h3 className="text-lg font-medium text-foreground">No projects found</h3>
            <p className="text-muted-foreground mt-1 max-w-xs mx-auto text-sm">Start by creating a company project to track its expenses.</p>
            <Link href="/admin/projects/add" className="mt-6 inline-block">
              <Button variant="outline" size="sm" className="rounded-xl px-6 font-medium">Create First Project</Button>
            </Link>
          </div>
        )}
      </div>
      <ConfirmModal 
        isOpen={deleteModal.isOpen}
        onClose={() => setDeleteModal({ ...deleteModal, isOpen: false })}
        onConfirm={handleDelete}
        title="Delete Project"
        message={`Are you sure you want to delete "${deleteModal.name}"? This will permanently remove all associated expenses and income records.`}
      />
    </div>
  );
}