var male_names = [
	"Jason",
	"Ned",
	"John",
	"Dave",
	"Adolf",
	"Sam",
	"Stuart",
	"Adam",
	"George",
	"Kevin",
	"Randy",
	"Damon",
	"Harry",
	"Lionel",
	"Willis",
	"Marion",
	"Joel",
	"Clint",
	"Jay",
	"Marvin",
	"Grady",
	"Horace",
	"Jackie",
	"Mark",
	"Tommie",
	"Brett",
	"Malcolm",
	"Trevor",
	"Shane",
	"Frank",
]

var female_names = [
	"Addison",
	"Ainsley",
	"Bailey",
	"Sam",
	"Mona",
	"Sheila",
	"Rosemary",
	"Dixie",
	"Sally",
	"Patti",
	"Gina",
	"Sheryl",
	"Ida",
	"Jennifer",
	"Susie",
	"Hannah",
	"Muriel",
	"Wanda",
	"Geraldine",
	"Stacy",
	"Toni",
	"Maureen",
	"Kara",
	"Luz",
	"Tiffany",
	"Thelma",
	"Lydia",
	"Kelli",
]

var sur_names = [
	"Born",
	"Adams",
	"Aldrich",
	"Ashford",
	"Snyder",
	"Warner",
	"Griffin",
	"Chandler",
	"Ramsey",
	"Peterson",
	"Adams",
	"Collins",
	"Garcia",
	"Lane",
	"Garner",
	"Stokes",
	"Santos",
	"Vasquez",
	"Barker",
	"Parker",
	"Gibbs",
	"Nichols",
	"Carlson",
]

var warrants = [
	"Shooting",
	"Car theft",
	"Shoplifting",
	"Resisting arrest",
	"Prisoner escapee",
	"Hit & Run",
	"Assault",
	"Armed robbery",
	"Mugger",
	"Loitering",
]

var jobs = [
	{ name:"Cleaner", income: "$25.000 Yearly"},
	{ name:"CEO", income: "$425.000 Yearly"},
	{ name:"Shop owner", income: "$45.000 Yearly"},
	{ name:"FIB Employee", income: "$35.000 Yearly"},
	{ name:"Computer repairman", income: "$25.000 Yearly"},
	{ name:"Prostitute", income: "$55.000 Yearly"},
	{ name:"Office worker", income: "$35.000 Yearly"},
	{ name:"Office worker", income: "$35.000 Yearly"},
	{ name:"Office worker", income: "$35.000 Yearly"},
	{ name:"Dancer", income: "$35.000 Yearly"},
	{ name:"DJ", income: "$65.000 Yearly"},
	{ name:"S.W.A.T", income: "$45.000 Yearly"},
	{ name:"Part-time cashier", income: "$15.000 Yearly"},
	{ name:"Cashier", income: "$27.500 Yearly"},
	{ name:"Car mechanic", income: "$27.500 Yearly"},
	{ name:"Private Investigator", income: "$57.500 Yearly"},
	{ name:"Ammunation Owner", income: "$35.000 Yearly"},
	{ name:"Programmer", income: "$45.000 Yearly"},
	{ name:"Amateur Racer", income: "$25.000 Yearly"},
	{ name:"Pro Racer", income: "$55.000 Yearly"},
	{ name:"Criminal Informant", income: "<REDACTED>"},
]

function getRandomProfile(s, f){
	var profile = {}
	if(s == 0)
		profile.name = male_names[Math.floor(Math.random() * male_names.length)] + " " + sur_names[Math.floor(Math.random() * sur_names.length)]
	else
		profile.name = female_names[Math.floor(Math.random() * female_names.length)] + " " + sur_names[Math.floor(Math.random() * sur_names.length)]
	profile.warrant = getWarrant(f)
	profile.job = jobs[Math.floor(Math.random() * Object.keys(jobs).length)]
	
	return profile
}

function getWarrant(c){
	var chance = Math.random() * 100
	if(c != null){
		return warrants[Math.floor(Math.random() * warrants.length)]
	}
	if(chance < 15){
		return warrants[Math.floor(Math.random() * warrants.length)]
	}else
		return "None"
}