gigabytes = &(&1 * 1024)

plans = [
  %{
    id: 1,
    slug: "appetizer",
    name: "Appetizer",
    storage_megabytes: 100,
    transfer_megabytes: gigabytes.(1),
    allow_domain: false,
    max_members: 1,
    fee_percent: 10,
    price_cents: 0
  },
  %{
    id: 2,
    slug: "snack",
    name: "Snack",
    storage_megabytes: gigabytes.(1),
    transfer_megabytes: gigabytes.(8),
    allow_domain: true,
    max_members: 5,
    fee_percent: 10,
    price_cents: 5_00
  },
  %{
    id: 3,
    slug: "meal",
    name: "Meal",
    storage_megabytes: gigabytes.(6),
    transfer_megabytes: gigabytes.(35),
    allow_domain: true,
    max_members: 25,
    fee_percent: 10,
    price_cents: 20_00
  },
  %{
    id: 4,
    slug: "buffet",
    name: "Buffet",
    storage_megabytes: gigabytes.(30),
    transfer_megabytes: gigabytes.(200),
    allow_domain: true,
    max_members: 1000,
    fee_percent: 10,
    price_cents: 120_00
  }
]

Enum.each(plans, fn plan ->
  existing_plan = Videosnack.Repo.get(Videosnack.Plan, plan.id)

  (existing_plan && Videosnack.Repo.update!(Videosnack.Plan.changeset(existing_plan, plan))) ||
    Videosnack.Repo.insert!(Videosnack.Plan.changeset(%Videosnack.Plan{}, plan))
end)
