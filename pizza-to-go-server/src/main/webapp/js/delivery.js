
window.onload = function () {
    // process();
    process();
}

function process() {
    fetch('http://localhost:9080/pizza-to-go-server/app/delivery/222', {
        method: 'get',
        headers: {
            'Content-type': 'application/json'
        }
    }).then((response) => response.json())
        .then(data => {
            console.log(data[0].id);
            console.log(data[0].status);
            console.log(data);

            processStatus(data[0].status);
            // if(data[0].status == "DELIVERED"){
            //     document.getElementById("container").classList.remove('box');
            //     document.getElementById("container").classList.add('hello');
            // } else {
            //     document.getElementById("container").classList.remove('box');
            //     document.getElementById("container").classList.add('hi');
            // }


            if (data.ok) {
                console.log(data);
            }
        })
        .catch(error => console.error('Error:', error));
}


// function load() {
// $.ajax({
// type: 'GET',
//     url: 'http://localhost:9080/pizza-to-go-server/app/delivery/222',
//     type: "GET",
//     dataType: "jsonp",
//     success: function (data) {
//         $('#main_container').html(dataType[0].status).delay(2000);
//         alert(data);
//     }
// });
// }

function processStatus(status) {
    // console.log(delivery[0].status);
    switch (status) {
        case "ORDERED":
            ordered();
            break;
        case "PREPARING":
            preparing();
            break;
        case "FINISHED":
            finished();
            break;
        case "ON_THE_WAY":
            onTheWay();
            break;
        case "DELIVERED":
            delivered();
            break;
    
        default:
            break;
    }
    function ordered() {
        document.getElementById("ORDERED").classList.remove('deactivated');
        document.getElementById("ORDERED").classList.add('activated');
        document.getElementById("ORDERED_A").classList.add('arrow-right');
        document.getElementById("ORDERED_A").classList.remove('arrow-right-d');
    }
    function preparing() {
        document.getElementById("PREPARING").classList.remove('deactivated');
        document.getElementById("PREPARING").classList.add('activated');
        document.getElementById("PREPARING_A").classList.add('arrow-right');
        document.getElementById("PREPARING_A").classList.remove('arrow-right-d');
        // document.getElementById("ORDERED").style.backgroundColor = "#546e7a";
        // document.getElementById("ORDERED_A").style.backgroundColor = "#546e7a";
    }
    function finished() {
        document.getElementById("FINISHED").classList.remove('deactivated');
        document.getElementById("FINISHED").classList.add('activated');
        document.getElementById("FINISHED_A").classList.add('arrow-right');
        document.getElementById("FINISHED_A").classList.remove('arrow-right-d');
        // preparing();
        // document.getElementById("PREPARING").style.backgroundColor = "#546e7a";
        // document.getElementById("PREPARING_A").style.backgroundColor = "#546e7a";
    }
    function onTheWay() {
        document.getElementById("ON_THE_WAY").classList.remove('deactivated');
        document.getElementById("ON_THE_WAY").classList.add('activated');
        document.getElementById("ON_THE_WAY_A").classList.add('arrow-right');
        document.getElementById("ON_THE_WAY_A").classList.remove('arrow-right-d');
    }
    function delivered() {
        document.getElementById("DELIVERED").classList.remove('deactivated');
        document.getElementById("DELIVERED").classList.add('activated');
        document.getElementById("DELIVERED_A").classList.add('arrow-right');
        document.getElementById("DELIVERED_A").classList.remove('arrow-right-d');
    }
}
var delivery = [
    {
        "id": 1064,
        "orderId": 222,
        "paymentStatus": "PAID_WITH_CARD",
        "status": "FINISHED",
        "username": "ujwal"
    }
];