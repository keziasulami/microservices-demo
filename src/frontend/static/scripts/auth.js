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
    } else {
        signinButton.style.display = "block";
        userName.innerHTML = "";
        userEmail.innerHTML = "(not signed in)";
    }
})

// sign in
signinButton.addEventListener('click', (e) => {
    signinButton.style.display = "none";
    loading.style.display = "block";

    var provider = new firebase.auth.GoogleAuthProvider();

    // Collect token when users sign in with their Google accounts
    auth.getRedirectResult().then(function(result) {
    if (result.credential && result.user) {
        const identityToken = result.credential.idToken;
        auth.currentUser.getIdToken(false).then(function(firebaseIdToken) {
            document.cookie = `firebase_id_token=${firebaseIdToken}`;
        })
    } else {
        // Redirect users to Google
        auth.signInWithRedirect(provider);
    }
    }).catch(function(error) {
        console.log(error);
    });
})

// sign out
signoutButton.addEventListener('click', (e) => {
    signoutButton.style.display = "none";
    dummy.style.display = "block"

    auth.signOut().then(function() {
        document.cookie = "firebase_id_token=;";
    }).catch(function (error) {
        console.log(error);
    });
})
