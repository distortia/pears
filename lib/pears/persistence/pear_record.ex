defmodule Pears.Persistence.PearRecord do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pears.Persistence.TeamRecord

  schema "pears" do
    field :name, :string
    belongs_to :team, TeamRecord, foreign_key: :team_id

    timestamps()
  end

  @doc false
  def changeset(pear_record, attrs) do
    pear_record
    |> cast(attrs, [:name, :team_id])
    |> validate_required([:name, :team_id])
    |> unique_constraint([:name, :team_id], name: :pears_team_id_name_index)
  end
end
