GM.Name = "FASTDM"
GM.Author = "Coconut Cunt"
GM.Email = "N/A"
GM.Website = "N/A"

--DeriveGamemode( "sandbox" )

DEFINE_BASECLASS( "Spectators" )

team.SetUp( 1, "Spectator", Color( 125, 125, 125, 255 ) )
team.SetUp( 2, "Terrorists", Color( 250, 175, 0, 255 ) )
team.SetUp( 3, "Counter Terrorists", Color( 71, 130, 255, 255 ) )

-- CT classes
team.SetUp( 4, "CT Assault", Color( 71, 130, 255, 255 ) )
team.SetUp( 5, "CT Medic", Color( 71, 130, 255, 255 ) )
team.SetUp( 6, "CT Sniper", Color( 71, 130, 255, 255 ) )
team.SetUp( 7, "CT Specialist", Color( 71, 130, 255, 255 ) )
team.SetUp( 8, "CT Juggernaut", Color( 71, 130, 255, 255 ) )

-- T classes
team.SetUp( 21, "T Assault", Color( 250, 175, 0, 255 ) )
team.SetUp( 22, "T Medic", Color( 250, 175, 0, 255 ) )
team.SetUp( 23, "T Sniper", Color( 250, 175, 0, 255 ) )
team.SetUp( 24, "T Specialist", Color( 250, 175, 0, 255 ) )
team.SetUp( 25, "T Juggernaut", Color( 250, 175, 0, 255 ) )

// credit to TCB for Stamina reference

// testing server name: FastDM Testing | Requires M9K