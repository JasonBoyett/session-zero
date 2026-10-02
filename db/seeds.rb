# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

unless Rails.env.development?
  return
end

DEFAULT_PASSWORD = "password"
AVATAR_BASE_URL = "https://api.dicebear.com/9.x/adventurer/svg".freeze

def seed_user!(email:, name:, avatar_seed:)
  user = User.find_or_initialize_by(email:)
  user.name = name
  user.profile_picture = "#{AVATAR_BASE_URL}?seed=#{avatar_seed}"

  if user.new_record? || user.encrypted_password.blank?
    user.password = DEFAULT_PASSWORD
    user.password_confirmation = DEFAULT_PASSWORD
  end

  user.save!
  user
end

def seed_gm_profile!(user:, name:, bio:, systems:, avatar_seed:, is_user_public: false)
  profile = user.game_master_profiles.find_or_initialize_by(name:)
  profile.bio = bio
  profile.systems = systems
  profile.profile_picture = "#{AVATAR_BASE_URL}?seed=#{avatar_seed}"
  profile.is_user_public = is_user_public
  profile.save!
  profile
end

def seed_game!(gm_profile:, name:, system:, description:, is_session_zero_complete:)
  game = gm_profile.games.find_or_initialize_by(name:)
  game.system = system
  game.description = description
  game.is_session_zero_complete = is_session_zero_complete
  game.save!
  game
end

def seed_player_profile!(
  user:,
  game:,
  character_name:,
  character_description:,
  character_sheet_link:,
  character_image_seed:,
  is_user_public: false,
  is_accepted:
)
  profile = PlayerProfile.find_or_initialize_by(user:, game:, character_name:)
  profile.character_description = character_description
  profile.character_sheet_link = character_sheet_link
  profile.character_image = "#{AVATAR_BASE_URL}?seed=#{character_image_seed}"
  profile.is_user_public = is_user_public
  profile.is_accepted = is_accepted
  profile.save!
  profile
end

def seed_line!(game:, player_profile:, title:, description:, is_anonymous:)
  line = Line.find_or_initialize_by(game:, player_profile:, title:)
  line.description = description
  line.is_anonymous = is_anonymous
  line.save!
  line
end

def seed_veil!(game:, player_profile:, title:, description:, is_anonymous:)
  veil = Veil.find_or_initialize_by(game:, player_profile:, title:)
  veil.description = description
  veil.is_anonymous = is_anonymous
  veil.save!
  veil
end

users = {
  developer: seed_user!(
    email: "dev@session-zero.fyi",
    name: "Developer",
    avatar_seed: "Developer"
  ),
  alex: seed_user!(
    email: "alex@session-zero.fyi",
    name: "Alex Mercer",
    avatar_seed: "Alex"
  ),
  jamie: seed_user!(
    email: "jamie@session-zero.fyi",
    name: "Jamie Wren",
    avatar_seed: "Jamie"
  ),
  casey: seed_user!(
    email: "casey@session-zero.fyi",
    name: "Casey Vale",
    avatar_seed: "Casey"
  ),
  morgan: seed_user!(
    email: "morgan@session-zero.fyi",
    name: "Morgan Ash",
    avatar_seed: "Morgan"
  ),
  riley: seed_user!(
    email: "riley@session-zero.fyi",
    name: "Riley Quill",
    avatar_seed: "Riley"
  ),
  taylor: seed_user!(
    email: "taylor@session-zero.fyi",
    name: "Taylor Fox",
    avatar_seed: "Taylor"
  ),
  jordan: seed_user!(
    email: "jordan@session-zero.fyi",
    name: "Jordan Pike",
    avatar_seed: "Jordan"
  )
}

gm_profiles = {
  hearth: seed_gm_profile!(
    user: users[:developer],
    name: "Rowan Hearth",
    bio: "Warm, family-friendly GM who loves gentle stakes, brave kids, talking animals, clear table expectations, and safety tools that are easy to use.",
    systems: [ "Quest", "Tiny Dungeon", "Dungeons and Dragons 5e" ],
    avatar_seed: "Rowan Hearth",
    is_user_public: true
  ),
  bloodletter: seed_gm_profile!(
    user: users[:developer],
    name: "Vex Bloodletter",
    bio: "Messy, profanity-friendly chaos GM for dangerous dungeons, doomed bargains, bad ideas, and tables where the plan often starts with fuck it.",
    systems: [ "Mork Borg", "Old-School Essentials", "Dungeons and Dragons 5e" ],
    avatar_seed: "Vex Bloodletter"
  ),
  cantever: seed_gm_profile!(
    user: users[:developer],
    name: "Cantever Sayno",
    bio: "Chronically overcommitted GM who cannot stop starting new campaigns, one-shots, playtests, side arcs, convention tables, and probably a podcast.",
    systems: [ "Dungeons and Dragons 5e", "Pathfinder 2e", "Fate", "Blades in the Dark", "Quest" ],
    avatar_seed: "Cantever Sayno"
  ),
  oracle: seed_gm_profile!(
    user: users[:alex],
    name: "The Glass Oracle",
    bio: "Sci-fi mystery facilitator who likes slow-burn reveals, weird artifacts, faction pressure, and character secrets with consent.",
    systems: [ "Stars Without Number", "Scum and Villainy", "Fate" ],
    avatar_seed: "Glass Oracle"
  ),
  lantern: seed_gm_profile!(
    user: users[:morgan],
    name: "Moss Under Lanterns",
    bio: "Folklore and horror GM focused on dread, moral choices, haunted places, and firm boundaries around what appears on screen.",
    systems: [ "Monster of the Week", "Vaesen", "Blades in the Dark" ],
    avatar_seed: "Moss Under Lanterns"
  )
}

games = {
  honeycake: seed_game!(
    gm_profile: gm_profiles[:hearth],
    name: "The Honeycake Road",
    system: "Quest",
    description: "A cozy travel-fantasy campaign about young heroes carrying festival recipes, family secrets, and a lantern that points toward people who need help.",
    is_session_zero_complete: true
  ),
  ashen_crown: seed_game!(
    gm_profile: gm_profiles[:bloodletter],
    name: "Blood on the Ashen Crown",
    system: "Mork Borg",
    description: "A grim, profane dungeon crawl about traitors, cursed saints, bad decisions, and desperate bastards trying to steal a crown from a dead tyrant.",
    is_session_zero_complete: false
  ),
  europa: seed_game!(
    gm_profile: gm_profiles[:oracle],
    name: "Signal Fires of Europa",
    system: "Stars Without Number",
    description: "A tense survival mystery on an ice moon where the distress beacon keeps broadcasting in voices the crew recognizes.",
    is_session_zero_complete: true
  ),
  lantern_road: seed_game!(
    gm_profile: gm_profiles[:hearth],
    name: "The Lantern Road",
    system: "Dungeons and Dragons 5e",
    description: "A new, low-prep campaign shell for testing empty states, invitations, and early session-zero setup.",
    is_session_zero_complete: false
  ),
  blackwater: seed_game!(
    gm_profile: gm_profiles[:lantern],
    name: "Blackwater Parish",
    system: "Vaesen",
    description: "A gothic folk-horror table about a flooded village, vanished bells, and the bargains people make when the road home disappears.",
    is_session_zero_complete: false
  )
}

[
  [ "The Seventeenth Session Zero", "Dungeons and Dragons 5e", "A campaign planning table for players who all arrived with secret heirs, forbidden magic, and incompatible calendars.", false ],
  [ "Oops All Clerics", "Pathfinder 2e", "A temple road trip where every miracle creates paperwork and every village needs one more blessing before breakfast.", true ],
  [ "The Dungeon Under the Dungeon", "Old-School Essentials", "A classic crawl that keeps revealing worse basements, stranger maps, and notes from parties who quit while ahead.", false ],
  [ "Moonlit Side Quest Club", "Quest", "A gentle episodic table about friends solving small problems that somehow keep becoming emotionally important.", true ],
  [ "The Archive That Bites", "Fate", "Scholars, thieves, and cursed librarians negotiate with books that remember every hand that opened them.", false ],
  [ "Blades of Bookkeeping", "Blades in the Dark", "A crew of criminals discovers the real score is fixing the ledger before the auditors become ghosts.", true ],
  [ "Festival of Bad Omens", "Monster of the Week", "A small-town celebration where every pie contest, parade float, and raffle ticket points toward a monster.", false ],
  [ "Starship Group Project", "Scum and Villainy", "A stressed crew tries to keep one patched-together ship flying while everyone has a different definition of success.", false ],
  [ "The Goblet Is Clearly Haunted", "Dungeons and Dragons 5e", "A royal tournament mystery where the prize talks back and the bracket keeps rearranging itself overnight.", true ],
  [ "Caverns and Committee Meetings", "Pathfinder 2e", "Adventurers split their time between tactical delves and the increasingly political guild that funds them.", false ],
  [ "The Orchard at the End", "Quest", "A pastoral fantasy about lost roads, talking fruit trees, and promises made to people who are no longer here.", true ],
  [ "Neon Familiar", "Fate", "Urban fantasy investigators follow a magical pet through subway omens, apartment wards, and deeply weird tenant meetings.", false ],
  [ "The Tomb Has Notes", "Old-School Essentials", "A trap-heavy ruin where previous delvers left annotations, warnings, complaints, and one very confident recipe.", false ],
  [ "Court of Borrowed Masks", "Dungeons and Dragons 5e", "A social intrigue game about masked bargains, identity swaps, and the cost of being believed.", true ],
  [ "The Lighthouse Below", "Vaesen", "A coastal mystery where the lighthouse beam shines upward from under the sea and people pretend that is normal.", false ],
  [ "Everyone Is the Chosen One", "Fate", "A prophecy comedy where five heroes each have airtight proof that destiny picked them specifically.", true ],
  [ "The Quiet Apocalypse", "Monster of the Week", "A slow-burn mystery where the end of the world starts as missed appointments, empty shelves, and polite denial.", false ],
  [ "Heist at Grandma's House", "Blades in the Dark", "A low-stakes, high-chaos caper where the crew must retrieve a relic before family dinner gets complicated.", true ],
  [ "Dragon Boat HOA", "Dungeons and Dragons 5e", "Neighbors on a floating settlement argue about dock rules, dragon visits, and whose turn it is to fight pirates.", false ],
  [ "The Campaign I Swore Was Tiny", "Quest", "A supposed three-session experiment that already has factions, custom lore, and a suspiciously detailed calendar.", false ]
].each_with_index do |(name, system, description, is_session_zero_complete), index|
  games[:"cantever_#{index + 1}"] = seed_game!(
    gm_profile: gm_profiles[:cantever],
    name:,
    system:,
    description:,
    is_session_zero_complete:
  )
end

players = {}

players[:mira] = seed_player_profile!(
  user: users[:alex],
  game: games[:honeycake],
  character_name: "Mira Vale",
  character_description: "A careful cartographer who maps kindness as seriously as roads.",
  character_sheet_link: "https://example.com/sheets/mira-vale",
  character_image_seed: "Mira Vale",
  is_accepted: true
)
players[:tav] = seed_player_profile!(
  user: users[:jamie],
  game: games[:honeycake],
  character_name: "Tav Ren",
  character_description: "A temple cook with a bottomless soup pot and a habit of feeding enemies before forgiving them.",
  character_sheet_link: "https://example.com/sheets/tav-ren",
  character_image_seed: "Tav Ren",
  is_accepted: true
)
players[:oona] = seed_player_profile!(
  user: users[:casey],
  game: games[:honeycake],
  character_name: "Oona Bell",
  character_description: "A tiny knight with a wooden sword, a huge oath, and no patience for bullies.",
  character_sheet_link: "https://example.com/sheets/oona-bell",
  character_image_seed: "Oona Bell",
  is_accepted: true
)
players[:finch] = seed_player_profile!(
  user: users[:riley],
  game: games[:honeycake],
  character_name: "Finch Marrow",
  character_description: "A shy mushroom scholar who can identify every snack in the forest and almost no social cues.",
  character_sheet_link: "https://example.com/sheets/finch-marrow",
  character_image_seed: "Finch Marrow",
  is_accepted: true
)

players[:knives] = seed_player_profile!(
  user: users[:alex],
  game: games[:ashen_crown],
  character_name: "Brother Knives",
  character_description: "A faithless cleric with a stolen reliquary, a ruined smile, and a plan that gets worse every time he explains it.",
  character_sheet_link: "https://example.com/sheets/brother-knives",
  character_image_seed: "Brother Knives",
  is_accepted: true
)
players[:static] = seed_player_profile!(
  user: users[:jamie],
  game: games[:ashen_crown],
  character_name: "Saint Static",
  character_description: "A doomed prophet who hears the apocalypse as radio noise.",
  character_sheet_link: "https://example.com/sheets/saint-static",
  character_image_seed: "Saint Static",
  is_accepted: true
)
players[:gutter] = seed_player_profile!(
  user: users[:morgan],
  game: games[:ashen_crown],
  character_name: "Gutter Psalm",
  character_description: "A mercenary poet who writes elegies before fights, mostly for people he plans to kill.",
  character_sheet_link: "https://example.com/sheets/gutter-psalm",
  character_image_seed: "Gutter Psalm",
  is_accepted: true
)
players[:nell] = seed_player_profile!(
  user: users[:taylor],
  game: games[:ashen_crown],
  character_name: "Nell Brindle",
  character_description: "A courier with forbidden letters stitched inside her coat.",
  character_sheet_link: "https://example.com/sheets/nell-brindle",
  character_image_seed: "Nell Brindle",
  is_accepted: false
)

players[:juno] = seed_player_profile!(
  user: users[:developer],
  game: games[:europa],
  character_name: "Juno Calder",
  character_description: "A systems tech who keeps hearing their dead sibling in the station alarms.",
  character_sheet_link: "https://example.com/sheets/juno-calder",
  character_image_seed: "Juno Calder",
  is_user_public: true,
  is_accepted: true
)
players[:iox] = seed_player_profile!(
  user: users[:casey],
  game: games[:europa],
  character_name: "Iox",
  character_description: "An oracle built from obsolete ship parts and three illegal memories.",
  character_sheet_link: "https://example.com/sheets/iox",
  character_image_seed: "Iox",
  is_accepted: true
)
players[:malik] = seed_player_profile!(
  user: users[:riley],
  game: games[:europa],
  character_name: "Malik Sato",
  character_description: "A medic who has patched up everyone except himself.",
  character_sheet_link: "https://example.com/sheets/malik-sato",
  character_image_seed: "Malik Sato",
  is_accepted: true
)

players[:pippa] = seed_player_profile!(
  user: users[:jordan],
  game: games[:lantern_road],
  character_name: "Pippa Thistle",
  character_description: "An apprentice beekeeper waiting for the campaign premise to take shape.",
  character_sheet_link: "https://example.com/sheets/pippa-thistle",
  character_image_seed: "Pippa Thistle",
  is_accepted: false
)

players[:developer_blackwater] = seed_player_profile!(
  user: users[:developer],
  game: games[:blackwater],
  character_name: "Eli Ward",
  character_description: "A former bell-ringer returning home with mud on his boots and a name nobody says aloud.",
  character_sheet_link: "https://example.com/sheets/eli-ward",
  character_image_seed: "Eli Ward",
  is_accepted: false
)
players[:sable] = seed_player_profile!(
  user: users[:jamie],
  game: games[:blackwater],
  character_name: "Sable Reed",
  character_description: "A folklore collector who knows exactly which local songs leave out the bodies.",
  character_sheet_link: "https://example.com/sheets/sable-reed",
  character_image_seed: "Sable Reed",
  is_accepted: true
)
players[:bram] = seed_player_profile!(
  user: users[:taylor],
  game: games[:blackwater],
  character_name: "Bram Hollow",
  character_description: "A ferryman with a ledger full of crossings that never happened.",
  character_sheet_link: "https://example.com/sheets/bram-hollow",
  character_image_seed: "Bram Hollow",
  is_accepted: true
)

[
  [ games[:honeycake], players[:mira], "Graphic harm to animals", "Animals can be threatened in broad terms, but no detailed injury or death on screen.", false ],
  [ games[:honeycake], players[:tav], "Bullying as comedy", "Mean behavior can happen, but it should not be played as a joke at a character's expense.", true ],
  [ games[:ashen_crown], players[:knives], "Sexual violence", "Do not include this as backstory, threat, joke, implication, or plot device.", true ],
  [ games[:ashen_crown], players[:static], "Loss of player agency", "Mind control and possession need explicit opt-in before they affect a player character.", false ],
  [ games[:europa], players[:juno], "Suffocation detail", "Space hazards are fine, but do not linger on choking, panic breathing, or decompression body horror.", false ],
  [ games[:europa], players[:malik], "Medical gore", "Injuries can matter mechanically, but keep surgery and wounds non-graphic.", true ],
  [ games[:blackwater], players[:sable], "Harm to children", "Children can be part of the story, but no direct harm, death, or threat scenes.", true ],
  [ games[:blackwater], players[:bram], "Real-world hate speech", "Bigotry can be implied as part of a cruel world, but slurs and targeted harassment stay off screen.", false ]
].each do |game, player_profile, title, description, is_anonymous|
  seed_line!(game:, player_profile:, title:, description:, is_anonymous:)
end

[
  [ games[:honeycake], players[:oona], "Spiders", "Spiders can appear as silly obstacles, but avoid swarms, close-up descriptions, or crawling on bodies.", false ],
  [ games[:honeycake], players[:finch], "Family separation", "Temporary separation is okay when handled gently and resolved with care.", true ],
  [ games[:ashen_crown], players[:gutter], "Torture", "It can exist as a grim fact of the world, but cut away before methods, screams, or aftermath detail.", true ],
  [ games[:ashen_crown], players[:knives], "PvP betrayal", "Betrayal is on theme, but check in before irreversible character consequences.", false ],
  [ games[:europa], players[:iox], "Identity horror", "Memory edits and clones are okay, but avoid extended scenes of losing personhood.", true ],
  [ games[:europa], players[:juno], "Romance", "Romance is welcome, explicit sexual content fades to black.", false ],
  [ games[:blackwater], players[:developer_blackwater], "Drowning imagery", "Floods and water dread are central, but avoid prolonged drowning descriptions.", true ],
  [ games[:blackwater], players[:sable], "Religious trauma", "Use fictional faiths and avoid one-to-one real religious abuse details.", false ]
].each do |game, player_profile, title, description, is_anonymous|
  seed_veil!(game:, player_profile:, title:, description:, is_anonymous:)
end

puts "Seeded #{User.count} users, #{GameMasterProfile.count} GM profiles, #{Game.count} games, #{PlayerProfile.count} player profiles, #{Line.count} lines, and #{Veil.count} veils."
