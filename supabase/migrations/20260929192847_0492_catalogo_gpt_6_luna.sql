-- ---------------------------------------------------------------------------
-- 0492 — GPT-6 Luna passa a ser uma opção de modelo OpenAI para os agentes.
--
-- Identificador, contexto e capacidades verificados em:
-- https://developers.openai.com/api/docs/models/gpt-6-luna (2026-09-29)
-- Tarifa Standard até 272K de entrada: US$ 0,10 entrada, US$ 0,50 saída por
-- milhão; cache read US$ 0,01 e cache write US$ 0,125 por milhão. Acima de
-- 272K, input/cache custam 2x e output 1,5x em toda a chamada.
--
-- pricing.ts aplica os preços de cache e o escalonamento de contexto longo;
-- lib/ai/cost.ts aplica a mesma faixa às outras chamadas contabilizadas.
-- Catálogo e ai_pricing guardam a tarifa curta, unidade centavos por milhão.
-- ---------------------------------------------------------------------------
insert into public.ai_models
  (provider, model_id, display_name, description, context_window,
   input_price_per_million_cents, output_price_per_million_cents,
   supports_tools, supports_vision)
values
  ('openai', 'gpt-6-luna', 'GPT-6 Luna',
   'Modelo GPT-6 eficiente para tarefas de volume, com ferramentas e imagens. A tarifa de contexto longo começa acima de 272 mil tokens de entrada.',
   1050000, 10, 50, true, true)
on conflict (provider, model_id) do update set
  display_name = excluded.display_name,
  description = excluded.description,
  context_window = excluded.context_window,
  input_price_per_million_cents = excluded.input_price_per_million_cents,
  output_price_per_million_cents = excluded.output_price_per_million_cents,
  supports_tools = excluded.supports_tools,
  supports_vision = excluded.supports_vision,
  deprecated_at = null;

insert into public.ai_pricing
  (model, prompt_cents_per_million_tokens, completion_cents_per_million_tokens, notes)
values
  ('gpt-6-luna', 10, 50, 'catálogo 0492 — tarifa Standard até 272K; contexto longo escalonado; developers.openai.com/api/docs/models/gpt-6-luna, medido em 2026-09-29')
on conflict (model) do update set
  prompt_cents_per_million_tokens = excluded.prompt_cents_per_million_tokens,
  completion_cents_per_million_tokens = excluded.completion_cents_per_million_tokens,
  notes = excluded.notes,
  superseded_at = null;
