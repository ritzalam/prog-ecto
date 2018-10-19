#---
# Excerpted from "Programming Ecto",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wmecto for more book information.
#---
defmodule MusicDB.Repo.Migrations.AddCompositionArtistsTable do
  use Ecto.Migration
  import Ecto.Query
  alias MusicDB.Repo

  def down do
    alter table("compositions") do
      add :artist_id, references("artists")
    end

    flush()

    from(ca in "compositions_artists", where: ca.role == "composer",
         select: [:composition_id, :artist_id])
    |> Repo.all()
    |> Enum.each(fn row ->
      Repo.update_all(
        from(c in "compositions", where: c.id == ^row.composition_id),
        set: [artist_id: row.artist_id]
      )
    end)

    drop table("compositions_artists")
  end
end
