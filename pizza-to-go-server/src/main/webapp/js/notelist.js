"using strict";

window.onload = function () {

	warenkorb();
	petTemplate(pizza);
	summe();

	// fetch('pizza.json').then(response => {
	// 	return response.json();
	//   }).then(data => {

	// 	console.log(data);
	//   }).catch((error) => console.error(error));


	var input = document.querySelector("#pwd");
	input.addEventListener("keyup",
		function () {
			var passwd = input.value;
			checkPassword(passwd);
		},
		false);

}


function showRegistration() {
	document.querySelector("#registration").style.display = "block";
	document.querySelector("#anmeldung").style.display = "none";
	document.querySelector("#app").style.display = "none";
	document.querySelector("#showinfo").style.display = "none";

	// document.getElementById("registration").style.display = "block";
}

function hideAnmeldung() {
	document.querySelector("#anmeldung").style.display = "none";
	document.querySelector("#app").style.display = "block";
	// document.getElementById("registration").style.display = "none";
}

function showAnmeldung() {
	document.querySelector("#anmeldung").style.display = "block";
	document.querySelector("#registration").style.display = "none";
	document.querySelector("#app").style.display = "none";

	document.querySelector("#showinfo").style.display = "none";

	// document.getElementById("registration").style.display = "block";
}

function hideRegistration() {
	document.querySelector("#registration").style.display = "none";
	document.querySelector("#app").style.display = "block";
	// document.getElementById("registration").style.display = "none";
}

function changeVisibility() {
	var x = document.querySelector("#access");
	if (x.style.display === "block") {
		x.style.display = "none";
	} else {
		x.style.display = "block";
	}

	var x = document.querySelector("#note");
	if (x.style.display === "none") {
		x.style.display = "block";
	} else {
		x.style.display = "none";
	}
}

//register
function registration(){
	var ort = document.getElementById("ort").value;
	var plz = document.getElementById("plz").value;
	var str = document.getElementById("street").value;
	var nr = document.getElementById("streetNr").value;
	document.getElementById("address").value = ""+plz+"§"+ort+"§"+str+"§"+nr;
	document.registrationForm.submit();
	hideRegistration()
}
//login
function login(){
	let data = { 
		username: document.getElementById("form-user").value, 
		password: document.getElementById("form-password").value
		};

	fetch('app/login',   {
	    method: 'post',
	    headers: {
	    	'Content-type': 'application/json' 
	    },
	    body: JSON.stringify(data)
	  })
	  .then( response => {
		    document.getElementById("form-user").value = "";
		    document.getElementById("form-password").value = "";
			if( !response.ok )
			{
				document.querySelector("#accessError").innerHTML = "Benutzerdaten sind fehlerhaft!";
				throw Error(response.statusText);
			}
			else
			{
				hideAnmeldung();
			}
		});
	changeVisibility();
}




// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Functions accessing LoginController
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function login() {
	let data = {
		username: document.querySelector("#username").value,
		password: document.querySelector("#password").value
	};

	fetch('app/login', {
		method: 'post',
		headers: {
			'Content-type': 'application/json'
		},
		body: JSON.stringify(data)
	})
		.then(response => {
			document.querySelector("#username").value = "";
			document.querySelector("#password").value = "";
			if (!response.ok) {
				document.querySelector("#accessError").innerHTML = "Benutzerdaten sind fehlerhaft!";
				throw Error(response.statusText);
			}
			else {
				changeVisibility();
				getNotes();
			}
		})
		.catch(error => console.error('Error:', error));
}

// Vorname prüfen
var nameOk = false;
var straßeOk = false;
var emailOk = false;
var straßeNrOk = false;
var plzOk = false;
var userOk = false;
var passwdOk = false;
var passwd2Ok = false;




function checkIfAllOk() {
	let allOk = nameOk && emailOk && straßeOk && straßeNrOk && plzOk && userOk && passwdOk && passwd2Ok;
	if (allOk) {
		document.querySelector("#btn").disabled = false;
	}
	else {
		document.querySelector("#btn").disabled = true;
	}
}

function logout() {
	fetch('app/login', {
		method: 'delete'
	})
		.then(response => {
			if (response.ok) {
				changeVisibility();
			}
		})
		.catch(error => console.error('Error:', error));
}


// Password 



function checkPassword() {
	var passwd = document.getElementById("pwd").value
	var len = passwd.length;
	var regExHasNumber = /\d/;
	var regExHasUpperCase = /[A-Z]/;
	var regExHasLowerCase = /[a-z]/;
	var regExHasSpecialSign = /[!?§$%&#*+-.]/;
	var hasNumber = regExHasNumber.test(passwd);
	var hasUpperCase = regExHasUpperCase.test(passwd);
	var hasLowerCase = regExHasLowerCase.test(passwd);
	var hasSpecialSign = regExHasSpecialSign.test(passwd);
	var size = 0;
	if (len >= 5) {
		passwdOk = true;
		size += 5;
		if (hasNumber) size += 5;
		if (hasUpperCase) size += 10;
		if (hasLowerCase) size += 5;
		if (hasSpecialSign) size += 10;

		if (len >= 7 && hasNumber && hasUpperCase && hasLowerCase && hasSpecialSign) size += 20;
	}
	else passwdOk = false;
	var c = document.querySelector("#pwdCanvas");
	var ctx = c.getContext("2d");
	ctx.fillStyle = "#FFFFFF";
	ctx.fillRect(0, 0, 155, 20);
	var grd = ctx.createLinearGradient(0, 0, size * 10, 0);
	grd.addColorStop(0, "green");
	grd.addColorStop(1, "red");
	ctx.fillStyle = grd;
	ctx.fillRect(0, 0, 155, 20);

	checkIfAllOk();

}	// ende Password

//2. Passwort abfrage
function checkPassword2(){
	var passwd = document.getElementById("pwd").value
	var passwd2 = document.getElementById("pwd2").value
	if (passwd == passwd2) {
		passwd2Ok = true;
	}
	else {
		passwd2Ok = false;
	}
	checkIfAllOk();
}

function checkPassword2OnFocus() {
	document.querySelector("#errorPassword2").innerHTML = "";
}

function checkPassword2OnBlur() {
	if (document.querySelector("#pwd2").value.length == 0)
		return;

	if (passwd2Ok == false) {
		document.querySelector("#errorPassword2").innerHTML = "Die Passwörter sind nicht identisch";
		// document.querySelector("#vrn").style.border = " solid 3px red";
	}
}
//Ende 2. Passwort abfrage


// Straße

function checkStraßeOnFocus() {
	document.querySelector("#errorStraße").innerHTML = "";
}

function checkStraßeOnBlur() {
	if (document.querySelector("#street").value.length == 0)
		return;

	if (straßeOk == false) {
		document.querySelector("#errorStraße").innerHTML = "Format des Straßes ist falsch";
		// document.querySelector("#vrn").style.border = " solid 3px red";
	}
}

function checkStraße() {
	let nameInput = document.querySelector("#street").value;
	if (nameInput.length === 0)
		return;

	let nameRegEx = /^[a-zäöüßA-ZÄÖÜ]{4,}$/;
	if (nameRegEx.test(nameInput) == false) {
		straßeOk = false;
	}
	else {
		straßeOk = true;
	}
	checkIfAllOk();
}

// ende Straße

// StraßeNr

function checkStraßeNrOnFocus() {
	document.querySelector("#errorStraßeNr").innerHTML = "";
}

function checkStraßeNrOnBlur() {
	if (document.querySelector("#streetNr").value.length == 0)
		return;

	if (straßeNrOk == false) {
		document.querySelector("#errorStraßeNr").innerHTML = "Format des StraßeNr ist falsch";
		// document.querySelector("#vrn").style.border = " solid 3px red";
	}
}

function checkStraßeNr() {
	let nameInput = document.querySelector("#streetNr").value;
	if (nameInput.length === 0)
		return;

	let nameRegEx = /^[1-9]{1,}$/;
	if (nameRegEx.test(nameInput) == false) {
		straßeNrOk = false;
	}
	else {
		straßeNrOk = true;
	}
	checkIfAllOk();
}

// ende StraßeNr

function checkVornameOnFocus() {
	document.querySelector("#errorVorname").innerHTML = "";
}

function checkVornameOnBlur() {
	if (document.querySelector("#vrn").value.length == 0)
		return;

	if (nameOk == false) {
		document.querySelector("#errorVorname").innerHTML = "Format des Vornamens ist falsch";
		// document.querySelector("#vrn").style.border = " solid 3px red";
	}
}

function checkVorname() {
	let nameInput = document.querySelector("#vrn").value;
	if (nameInput.length === 0)
		return;

	let nameRegEx = /^[A-ZÄÖÜ][a-zäöüßA-ZÄÖÜ]*[a-zäöüß]$/;
	if (nameRegEx.test(nameInput) == false) {
		nameOk = false;
	}
	else {
		nameOk = true;
	}
	checkIfAllOk();
}

// nachname


function checkNachnameOnFocus() {
	document.querySelector("#errorNachname").innerHTML = "";
}

function checkNachnameOnBlur() {
	if (document.querySelector("#nhn").value.length == 0)
		return;

	if (nameOk == false) {
		document.querySelector("#errorNachname").innerHTML = "Format des Nachnamens ist falsch";
	}
}

function checkNachname() {
	let nameInput = document.querySelector("#nhn").value;
	if (nameInput.length === 0)
		return;

	let nameRegEx = /^[A-ZÄÖÜ][a-zäöüßA-ZÄÖÜ]*[a-zäöüß]$/;
	if (nameRegEx.test(nameInput) == false) {
		nameOk = false;
	}
	else {
		nameOk = true;
	}
	checkIfAllOk();
}


// Email

function checkEmailOnFocus() {
	document.querySelector("#errorEmail").innerHTML = "";
}

function checkEmailOnBlur() {
	if (document.querySelector("#email").value.length == 0)
		return;

	if (emailOk == false) {
		document.querySelector("#errorEmail").innerHTML = "Format der E-Mail-Adresse ist falsch";
	}
}

function checkEmail() {
	emailOk = false;

	let emailInput = document.querySelector("#email").value;
	if (emailInput.length === 0)
		return;

	let emailRegEx = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
	if (emailRegEx.test(emailInput) == false) {
		emailOk = false;
	}
	else {
		emailOk = true;
	}

	checkIfAllOk();
}

// PLZ


function getPlzFromEscher() {
	plzOk = false;
	/*
	let value = document.querySelector('#plz').value;
	if (value.length != 5) {
		let divElement = document.querySelector("#ort");
		while (divElement.firstChild) {
			divElement.removeChild(divElement.firstChild);
		}
	}
	if (value.length == 5) {
		let url = 'http://escher.informatik.hs-kl.de/PlzService/ort?plz=' + value;
		fetch(url)
			.then((response) => response.text())
			.then((data) => {
				data.trim().slice(0, -1).split(";").forEach(ort => {
					console.log(ort);
					let liElement = document.createElement("option");
					liElement.innerHTML = ort.slice(6);
					document.querySelector("#ort").append(liElement);
				});
				if (document.querySelector("#ort").value.length != 0) plzOk = true;
			})
			.catch((error) => console.error(error));
	}
	// if (document.querySelector('#plz').value.length == 5 &&  plzOk = true;
	*/

	if (document.querySelector('#plz').value.length == 5) {
		plzOk = true;
	}
	else {
		plzOk = false;
	}
	checkIfAllOk();

}


function checkPlzOnFocus() {
	document.querySelector("#errorPlz").innerHTML = "";
}

function checkPlzOnBlur() {
	if (document.querySelector("#plz").value.length == 0)
		return;

	if (document.querySelector(plzOk == false)) { //"#plz").value.length != 0 && document.querySelector("#ort").value.length == 0) {
		document.querySelector("#errorPlz").innerHTML = "Format der PLZ ist falsch";
		//  plzOk = false;		
	}

	// else plzOk = true;
}
// BenutzerName

function checkUserOnFocus() {
	document.querySelector("#errorUser").innerHTML = "";
}

function checkUserOnBlur() {
	if (document.querySelector("#user").value.length == 0)
		return;

	if (userOk == false) {
		document.querySelector("#errorUser").innerHTML = "Format des Benutzernames ist falsch";
		// document.querySelector("#vrn").style.border = " solid 3px red";
	}
}

function checkUser() {
	let nameInput = document.querySelector("#user").value;
	if (nameInput.length === 0)
		return;

	let nameRegEx = /^[a-zäöüßA-ZÄÖÜ][a-zäöüßA-ZÄÖÜ1-9]{4,}$/;
	if (nameRegEx.test(nameInput) == false) {
		userOk = false;
	}
	else {
		userOk = true;
	}
	checkIfAllOk();
}

// ende BenutzerName


const pizza = [
	{
		"id": 1,
		"imagePath": "https://static.essen-und-trinken.de/bilder/6b/3f/58617/facebook_image/klassischer-burger.jpg",
		"name": "Classic Burger",
		"description": "with beef, cheese, onion, tomato, with beef, cheese, onion, tomato, with beef, cheese, onion, tomato",
		"price": {
			"classic": 5.5,
			"medium": 6.0,
			"large": 6.5
		}
	},
	{
		"id": 2,
		"imagePath": "https://img.delicious.com.au/0Hfc6oZG/w1200/del/2017/03/creamy-pumpkin-soup-43936-2.jpg",
		"name": "Pumpkin Soup",
		"description": "with pumpkins, Lorem ipsum dolor sit amet, consetetur sadipscing",
		"price": {
			"classic": 3.5,
			"medium": 4.0,
			"large": 5.5
		}
	},
	{
		"id": 3,
		"imagePath": "https://cdn.gutekueche.de/upload/rezept/141/1600x1200_pommes-frites-aus-belgien.jpg",
		"name": "Pommes",
		"description": "with ketchup",
		"price": {
			"classic": 4.5,
			"medium": 4.8,
			"large": 5.2
		}
	},
	{
		"id": 4,
		"imagePath": "https://cdn.gutekueche.de/upload/rezept/141/1600x1200_pommes-frites-aus-belgien.jpg",
		"name": "Pommes",
		"description": "with ketchup",
		"price": {
			"classic": 4.2,
			"medium": 4.6,
			"large": 5.3
		}
	}
];


const supplement = [
	{
		"id": 1,
		"imagePath": "Images//Cherrytomaten.jpg",
		"name": "Cherrytomaten",
		"price": 1.39
	},
	{
		"id": 2,
		"imagePath": "Images//Champignons.jpg",
		"name": "Champignons",
		"price": 0.75
	},
	{
		"id": 3,
		"imagePath": "Images//Oliven.jpg",
		"name": "Oliven",
		"price": 0.99
	},
	{
		"id": 4,
		"imagePath": "Images//Mais.jpg",
		"name": "Mais",
		"price": 0.80
	},
	{
		"id": 5,
		"imagePath": "Images//Chilisalami.jpg",
		"name": "Chilisalami",
		"price": 0.80
	},
	{
		"id": 6,
		"imagePath": "Images//Paprika.jpg",
		"name": "Paprika",
		"price": 0.99
	},
	{
		"id": 7,
		"imagePath": "Images//Bacon.jpg",
		"name": "Bacon",
		"price": 1.20
	},
	{
		"id": 8,
		"imagePath": "Images//Basilikum-Pesto.jpg",
		"name": "Basilikum-Pesto",
		"price": 0.60
	},
	{
		"id": 9,
		"imagePath": "Images//Blattspinat.jpg",
		"name": "Blattspinat",
		"price": 0.99
	},
	{
		"id": 10,
		"imagePath": "Images//Broccoli.jpg",
		"name": "Broccoli-Röschen",
		"price": 0.80
	}
];




function petTemplate(pizza) {

	var pizzaList = "";
	pizza.forEach(com => {
		pizzaList += '<div class="animal"><img class="pet-photo" src="'
			+ com.imagePath + '"> <h2 class="pet-name">' + com.name + ' </h2>  <p id="description2"> '
			+ com.description + '</p>  <p><span id="price"><strong >Preis:  </strong>'
			+ com.price.classic + ' €</span><span id="preis3"><a id="mehrInfo" onclick="showInfos('
			+ com.id + ')">Mehr Infos <i class="fas fa-info-circle"></i></a><button type="button" class="hinzufuegen" id="hinzufuegen" onclick="hinzufuegen('
			+ com.id + ')" ><i class="fas fa-cart-plus"></i></button>  </span> </p></div >';
	});
	document.querySelector("#app").innerHTML = pizzaList;
}
function register() {
	let data = {
		firstname: "Test",
		lastname: "user",
		username: document.querySelector("#username").value,
		password: document.querySelector("#password").value,
		email: "test@test.com",
		address: "irrgendwo Str"
	};

	fetch('app/users/add', {
		method: 'post',
		headers: {
			'Content-type': 'application/json'
		},
		body: JSON.stringify(data)
	})
		.then(response => {
			document.querySelector("#username").value = "";
			document.querySelector("#password").value = "";
			if (!response.ok) {
				document.querySelector("#accessError").innerHTML = "Benutzer existiert bereits!";
				throw Error(response.statusText);
			}
			else {
				changeVisibility();
				getNotes();
			}
		})
		.catch(error => console.error('Error:', error));
}

var array = [];
var w = 0;

function hinzufuegen(id) {

	var a = 1;
	pizza.forEach(com => {

		if (id == com.id) {

			if (array.some(item => item.pizza_id === id)) {

				var idx=index(array, "pizza_id", id);
				array[idx].Pizza_anzahl++;
				array[idx].Pizza_summe = array[idx].Pizza_preis * array[idx].Pizza_anzahl+summe_belege(id);

				w++;
				warenkorb();
				summe();
			}

			else {

				array.push({
					pizza_id: com.id,
					pizza_name: com.name,
					Pizza_image: com.imagePath,
					Pizza_preis: com.price.classic,
					Pizza_summe: com.price.classic* a +summe_belege(id),
					Pizza_description: com.description,
					Pizza_anzahl: a

				});

				w++;
				warenkorb();
				summe();

			}

		}

		showWarenkorb(array);

	});

}


function löschen(id) {

	w = w - array[index(array, "pizza_id", id)].Pizza_anzahl;
	warenkorb();
	array.forEach(com => {

		if (id == com.pizza_id) {

			const i = array.indexOf(com);
			if (i > -1) {
				array.splice(i, 1);
			}

			summe();
		}
	});
	console.log(array);

	showWarenkorb(array);

}

var suppl = [];

function showAktuelleZutaten(id) {

	var sup = "";

	suppl.forEach(e => {

		if (id == e.pizza_id) {


			sup += '<table class="suppl"><tr><td><i class="fas fa-minus-circle" onclick="suppl_löschen(' + e.supplement_id + ',' + e.pizza_id + ')"></i></td></tr><tr><td><img  class="photo_zutaten" src="'
				+ e.imagePath + '"></td><tr><td> <strong >'
				+ e.name + '</strong></td> </tr></tr><tr><td>' + e.price + ' €</td></tr></table>';

		}
	});

	document.querySelector("#aktuelleZutaten").innerHTML = sup;
}
function getNotes() {
	fetch('app/notes')
		.then(response => response.json())
		.then(data => printListe(data))
		.catch(error => console.error('Error:', error));
}

function clearNotes() {
	fetch('app/notes', { method: 'DELETE' })
		.then(response => fetch('app/notes'))
		.then(response => response.json())
		.then(data => printListe(data))
		.catch(error => console.error('Error:', error));
}

function addNote() {
	let data = {
		subject: document.querySelector("#subject").value,
		content: document.querySelector("#content").value
	};

	fetch('app/notes', {
		method: 'post',
		headers: {
			'Content-type': 'application/json'
		},
		body: JSON.stringify(data)
	})
		.then(response => fetch('app/notes'))
		.then(response => response.json())
		.then(data => printListe(data))
		.catch(error => console.error('Error:', error));
}


function suppl_löschen(s_id, p_id) {

	suppl.forEach(com => {

		if (p_id == com.pizza_id && s_id == com.supplement_id) {

			const i = suppl.indexOf(com);
			document.getElementById("preis_size").innerText = parseFloat(document.getElementById("preis_size").innerText) - com.price;

			if (i > -1) {
				suppl.splice(i, 1);
			}
			
		}

	});

	
	showAktuelleZutaten(p_id);
}
	
function printListe(data) {
	document.querySelector("#subject").value = "";
	document.querySelector("#content").value = "";

	let div = document.querySelector("#notelist");
	div.innerHTML = "";
	let ul = document.createElement("ul");
	div.append(ul);

	console.log(data);

	data.notes.forEach(item => {
		let li = document.createElement("li");
		li.append(item.creationDate + " : " + item.subject + " => " + item.content);
		ul.append(li);
	});
}

function suppl_hinzufügen(s_id, p_id) {

	var sum = 0;
	suppl.forEach(e => {

		if (e.pizza_id == p_id) {
			sum++; 
			
		}
	});

	if (sum == 3) {
		window.alert("Es sind nur maximal 3 auswählbare Zutaten für dieses Produkt möglich.");
		console.log(sum);
	}

	else {
		supplement.forEach(element => {

			if (s_id == element.id) {
				suppl.push({
					pizza_id: p_id,
					supplement_id: s_id,
					imagePath: element.imagePath,
					name: element.name,
					price: element.price

				});
				document.getElementById("preis_size").innerText = parseFloat(document.getElementById("preis_size").innerText)+ element.price;
			}
		});

	}
	showAktuelleZutaten(p_id);

}

function showInfos(id) {

	document.querySelector("#app").style.display = "none";
	document.querySelector("#showinfo").style.display = "block";
	// document.querySelector("#supplement").style.display = "block";
	var supplementTable = "";
	var summe = 0;



	pizza.forEach(com => {

		supplement.forEach(e => {

			if (id == com.id) {

				supplementTable += '<table class="suppl" onclick="suppl_hinzufügen(' + e.id + ',' + id + ')" ><tr><td style="height:50px;"><img  class="photo_zutaten" src="'
					+ e.imagePath + '"></td><tr><td> <strong >'
					+ e.name + '</strong></td> </tr></tr><tr><td>' + e.price + ' €</td></tr></table>';

			
				document.querySelector("#showinfo").innerHTML = '<div class="mehrinfos"  style="margin : 15px"> <h1 style="margin: 15Px;">' + com.name + '</h1>'
					+ '<hr style="height:1px;border-width:0;color:gray;background-color:gray; margin-left: 15px; margin-right: 15px; margin-bottom: 30px;"></hr>'
					+ '<table  style="margin:15px"><tr><td rowspan="5" id="td_img">'
					+ '<img class="photo" src="'
					+ com.imagePath + '"></td><tr><td style="vertical-align: top;text-align: left; "><h3>BESCHREIBUNG</h3><p class="description"> '
					+ com.description + '</p></td> </tr></tr>'
					+ '<tr><td style="vertical-align: top;text-align: left; padding-left:10px"><strong >AKTUELLE GRÖSSE  </strong><br> <select id="size" onchange="myFunction(' + id + ')">'
					+ '<option value="classic">Classic(25cm)</option>'
					+ '<option value="medium">Medium(28cm)</option>'
					+ '<option value="large">Large(32cm)</option>'
					+ '</select> </td></tr>'

					+ '<tr><td style="vertical-align: top;text-align: left; padding-left:10px"><br><strong>SUMME: </strong> <i id="preis_size">' + (com.price.classic + summe_belege(com.id)) + '</i> €</td></tr>'

					+ '<tr><td style="vertical-align: top;text-align: left; padding-left:10px"><br><strong >ANZAHL  </strong><br> '
					+ '<i class="fas fa-minus" onclick="minus(' + com.pizza_id + ')"></i> '
					+ '<input type="text" id="anzahl_input' + com.pizza_id + '" style="width: 30px; height: 30px; text-align: center;" value="" disabled /> '
					+ '<i class="fas fa-plus" onclick="plus(' + com.pizza_id + ')"></i>'

					+ ' </td></tr></table>'
					+ '<p>AKTUELLE ZUTATEN (Klicke <i class="fas fa-minus-circle"></i> zum entfernen)</p>'
					+ '<div id="aktuelleZutaten"></div>'
					+ '<p>ZUTATEN HINZUFÜGEN (Klicke zum hinzufügen)</p>'


					+ supplementTable

					+ ' <span id="info_zurück" style= " : 100"><a id="hideinfo" onclick="hideInfos()"><i class="fas fa-hand-point-left"></i> Zurück</a><button type="button" class="hinzufuegen1" id="hinzufuegen" onclick="hinzufuegen('
					+ com.id + ')" ><i class="fas fa-cart-plus"></i></button>  </span>'

					+ '</div >';
			}
		});


	});

	showAktuelleZutaten(id);
}



function showWarenkorb(array) {
	var warenkorb = "";
	var sup = "";
	array.forEach(com => {

		suppl.forEach(e => {

			if (com.pizza_id == e.pizza_id) {
				sup += '<li>' + e.name + '</li>';
			}
		});
		warenkorb += '<div class="showWarenkorb"> <h4 class="name">'
			+ com.pizza_name + ' </h4><ul>' + sup + '</ul><h4 class="anzahl"> '

			+ '<button type="button" class="minus"onclick="minus(' + com.pizza_id + ')"><i class="fas fa-minus">'
			+ '</i></button> <input type="text" id="anzahl_input' + com.pizza_id + '" style="width: 30px; height: 30px; text-align: center;" value="' + com.Pizza_anzahl + '" disabled /> '
			+ '<button type="button" class="plus" onclick="plus(' + com.pizza_id + ')"><i class="fas fa-plus"></i></button><span id="preis">Preis '
			+ '</span></h4> <span id="preis3"><span id="preis2">' + com.Pizza_summe
			+ ' €</span> <button type="button" class="löschen" id="löschen" onclick="löschen('
			+ com.pizza_id + ')"><i class="far fa-trash-alt"></i></button></span></div >';
	});

	document.querySelector("#warenkorb").innerHTML = warenkorb;
}



function hideInfos() {
	document.querySelector("#showinfo").style.display = "none";
	document.querySelector("#app").style.display = "block";


	// petTemplate(pizza);
}

function warenkorb() {
	document.querySelector(".active").innerHTML = '<i class="fas fa-cart-plus"></i><sup id="sup">' + w + '</sup>';

}

function summe() {

	var s = 0;
	if (array.length == 0) s = 0;
	else {
		array.forEach(element => {

			s += (element.Pizza_summe);
		});

	}

	document.querySelector("#summe_preis").innerHTML = s + ' €';
}

function plus(id) {


	var e = array[index(array, "pizza_id", id)];
	e.Pizza_anzahl++;
	e.Pizza_summe = e.Pizza_preis * e.Pizza_anzahl;

	// document.querySelector("#preis2").value = e.Pizza_summe;
	document.querySelector("#anzahl_input" + id).value = e.Pizza_anzahl;
	summe();
	showWarenkorb(array);

}
function minus(id) {

	var e = array[index(array, "pizza_id", id)];

	if (e.Pizza_anzahl != 1) {
		e.Pizza_anzahl--;
		e.Pizza_summe = e.Pizza_preis * e.Pizza_anzahl;


		// document.querySelector("#preis2").innerHTML = e.Pizza_summe;
		document.querySelector("#anzahl_input" + id).value = e.Pizza_anzahl;
		summe();
		showWarenkorb(array);


	}
	else { löschen(id); }

}

function index(arr, key, val) {
	for (var i = 0; i < arr.length; i++) {
		if (arr[i][key] === val) return i;
	}
}

function clearErrorMessage() {
	document.querySelector("#accessError").innerHTML = "";
}

function myFunction(id) {

	var x = document.getElementById("size").value;
	pizza.forEach(element => {


		if (id == element.id) {

			switch (x) {
				case "classic": document.querySelector("#preis_size").innerHTML =  element.price.classic + summe_belege(id) 	;

					break;
				case "medium": document.querySelector("#preis_size").innerHTML =  element.price.medium + summe_belege(id);

					break;

				default: document.querySelector("#preis_size").innerHTML = element.price.large + summe_belege(id);
					break;
			}
		}
	});



}

function summe_belege(id){
	var s = 0;
	suppl.forEach(element => {
		
		if(id == element.pizza_id){

			s+= element.price;

		}
	});
	return s;
}


function getBestellungen() {

}

function generateBestellungsView(){

}

function showBestellungen(){
	document.querySelector("#bestellungen").style.display = "block";
	document.querySelector("#registration").style.display = "none";
	document.querySelector("#app").style.display = "none";
	document.querySelector("#anmeldung").style.display = "none";
	document.querySelector("#showinfo").style.display = "none";
}

function hideBestellungen(){
	document.querySelector("#bestellungen").style.display = "none";
	document.querySelector("#app").style.display = "block";
}
function showBestellung(){
	document.querySelector("#bestellung").style.display = "block";
	document.querySelector("#bestellungen").style.display = "none";
}

function BestellungZurück(){
	document.querySelector("#bestellung").style.display = "none";
	document.querySelector("#bestellungen").style.display = "block";
}
function hideBestellung(){
	document.querySelector("#bestellung").style.display = "none";
	document.querySelector("#app").style.display = "block";
}