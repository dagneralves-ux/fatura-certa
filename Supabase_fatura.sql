-- Fatura Certa · sincronização (rode UMA vez no SQL Editor do Supabase)
-- Pode ser o mesmo projeto do DS Gestão: cria só uma tabela nova, sem mexer nas existentes.

create table if not exists public.fatura_dados (
  user_id       uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  dados         jsonb not null,
  atualizado_em timestamptz not null default now()
);

alter table public.fatura_dados enable row level security;

drop policy if exists "fatura_dados_dono" on public.fatura_dados;
create policy "fatura_dados_dono" on public.fatura_dados
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- Só quem está logado enxerga/grava, e apenas a própria linha.
