
// on the server
var users = {}; // all connected users

// Identify device and add to users at connection
io.sockets.on('connection', function (socket) {
    socket.emit('who are you');
    socket.on('check in', function (incoming) {
        users[incoming.majorMinorID] = socket.id;
    });
});
// Get socketID from user array and send URL to device
socket.on('message to partner', function(msg) {
	io.sockets.socket(users[msg.deviceID]).emit(msg.URL);
  });
});

// on the client
// Tell Server my deviceID
socket.on('who are you', function (incoming) {
    socket.emit('check in', {devideID: beaconMajor + beaconMinor});
});
// send URL to Partner
socket.emit('message to partner', {minorMajorID : "1233552345", url: "URL"});