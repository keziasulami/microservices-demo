const signinButton = document.querySelector('#signin-button');
const loading = document.querySelector('#loading');
const signoutButton = document.querySelector('#signout-button');
const dummy = document.querySelector('#dummy');

// listen for auth status changes
auth.onAuthStateChanged(user => {
    loading.style.display = "none";
    dummy.style.display = "none";

    const userName = document.querySelector('#user-name');
    const userEmail = document.querySelector('#user-email');

    if (user) {
        signoutButton.style.display = "block";
        userName.innerHTML = auth.currentUser.displayName;
        userEmail.innerHTML = " (" + auth.currentUser.email + ")";

        auth.currentUser.getIdToken(false).then(function(firebaseIdToken) {
            document.cookie = `firebase_id_token=${firebaseIdToken}`;
        }).catch(function (error) {
            console.log(error);
        });

        document.getElementById('email').value = auth.currentUser.email;
        document.getElementById('order-button').style.display = "block";

    } else {
        signinButton.style.display = "block";
        userName.innerHTML = "";
        userEmail.innerHTML = "(not signed in)";

        document.cookie = "firebase_id_token=;";

        document.getElementById('email').value = "PLEASE SIGN IN FIRST";
        document.getElementById('order-button').style.display = "none";
    }
})

// sign in
signinButton.addEventListener('click', (e) => {
    signinButton.style.display = "none";
    loading.style.display = "block";

    var provider = new firebase.auth.GoogleAuthProvider();

    // Redirect users to Google
    auth.signInWithRedirect(provider);
})

// sign out
signoutButton.addEventListener('click', (e) => {
    signoutButton.style.display = "none";
    dummy.style.display = "block"

    auth.signOut();
})
