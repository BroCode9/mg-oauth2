/*
 * Copyright 2018 Google LLC.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.levi9.mgoauth2.mgoauth2example.document;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.RequiresApi;
import android.support.constraint.ConstraintLayout;
import android.support.design.widget.Snackbar;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.util.Base64;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.ar.core.Anchor;
import com.google.ar.core.Frame;
import com.google.ar.core.HitResult;
import com.google.ar.core.Plane;
import com.google.ar.core.Session;
import com.google.ar.core.Trackable;
import com.google.ar.core.TrackingState;
import com.google.ar.core.exceptions.CameraNotAvailableException;
import com.google.ar.core.exceptions.UnavailableException;
import com.google.ar.sceneform.AnchorNode;
import com.google.ar.sceneform.ArSceneView;
import com.google.ar.sceneform.HitTestResult;
import com.google.ar.sceneform.Node;
import com.google.ar.sceneform.math.Vector3;
import com.google.ar.sceneform.rendering.ViewRenderable;
import com.levi9.mg.oauth2.mgoauth2example.R;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

import static com.levi9.mgoauth2.mgoauth2example.document.Constants.ACCESS_TOKEN_KEY;
import static com.levi9.mgoauth2.mgoauth2example.document.Constants.EMAIL_KEY;
import static com.levi9.mgoauth2.mgoauth2example.document.Constants.IMAGE_KEY;
import static com.levi9.mgoauth2.mgoauth2example.document.Constants.JOB_TITLE_KEY;
import static com.levi9.mgoauth2.mgoauth2example.document.Constants.OFFICE_LOCATION_KEY;
import static com.levi9.mgoauth2.mgoauth2example.document.Constants.USER_NAME_KEY;

public class DocumentActivity extends AppCompatActivity {
    private static final int RC_PERMISSIONS = 0x123;
    private boolean installRequested;

    private GestureDetector gestureDetector;
    private Snackbar loadingMessageSnackbar = null;
    private ArSceneView arSceneView;
    private ViewRenderable documentRenderable;

    // True once scene is loaded
    private boolean hasFinishedLoading = false;

    // True once the scene has been placed.
    private boolean hasPlacedDocumentSystem = false;

    private ConstraintLayout documentView;
    private ImageView userImage;
    private TextView userName;
    private TextView email;
    private TextView jobTitle;
    private TextView officeLocation;
    private TextView accessToken;

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    @SuppressWarnings({"AndroidApiChecker", "FutureReturnValueIgnored"})
    // CompletableFuture requires api level 24
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_document);

        View documentView = LayoutInflater.from(this)
                                          .inflate(R.layout.document_layout, null);
        userImage = documentView.findViewById(R.id.userImage);
        userName = documentView.findViewById(R.id.userName);
        email = documentView.findViewById(R.id.email);
        jobTitle = documentView.findViewById(R.id.jobTitle);
        officeLocation = documentView.findViewById(R.id.officeLocation);
        accessToken = documentView.findViewById(R.id.accessToken);

        // Mocked data - DELETE!!!
        userImage.setImageDrawable(ContextCompat.getDrawable(this, R.drawable.img));
        userName.setText("User Name");
        email.setText("u.name@levi9.com");
        jobTitle.setText("Job");
        officeLocation.setText("Office");
        accessToken.setText(
                "42FWLh4OPEkQ2YCE2x623PiStGraSpbozwkHu4QNg6FOrOg3HFxqFeQgCPd9Tau9YcimTLoOHIPg9kwFyWMPKJPnPwTDxZ0krEVMWhNtKLes6t1v36xCrRLYgh9U4JSEkiIQadfNzo3oUNijl4uc9ASOBfKXp40QhxH37IgkK8IV78DO9bfgSxsrLbi6dhZK9DJk3PgC");

        // Real data
//        userImage.setImageBitmap(getBitmapFromString(getIntentStringForKey(IMAGE_KEY)));
//        userName.setText(getIntentStringForKey(USER_NAME_KEY));
//        email.setText(getIntentStringForKey(EMAIL_KEY));
//        jobTitle.setText(getIntentStringForKey(JOB_TITLE_KEY));
//        officeLocation.setText(getIntentStringForKey(OFFICE_LOCATION_KEY));
//        accessToken.setText(getIntentStringForKey(ACCESS_TOKEN_KEY));

        if (!DemoUtils.checkIsSupportedDeviceOrFinish(this)) {
            // Not a supported device.
            return;
        }

        arSceneView = findViewById(R.id.ar_scene_view);

        // Build a renderable from a 2D View.
        CompletableFuture<ViewRenderable> documentControlStage = ViewRenderable.builder()
                                                                               .setView(this, documentView)
                                                                               .build();

        CompletableFuture.allOf(documentControlStage)
                         .handle((notUsed, throwable) -> {
                             // When you build a Renderable, Sceneform loads its resources in the background while
                             // returning a CompletableFuture. Call handle(), thenAccept(), or check isDone()
                             // before calling get().

                             if (throwable != null) {
                                 DemoUtils.displayError(this, "Unable to load renderable", throwable);
                                 return null;
                             }

                             try {
                                 documentRenderable = documentControlStage.get();

                                 // Everything finished loading successfully.
                                 hasFinishedLoading = true;

                             } catch (InterruptedException | ExecutionException ex) {
                                 DemoUtils.displayError(this, "Unable to load renderable", ex);
                             }

                             return null;
                         });

        // Set up a tap gesture detector.
        gestureDetector = new GestureDetector(this, new GestureDetector.SimpleOnGestureListener() {
            @Override
            public boolean onSingleTapUp(MotionEvent e) {
                onSingleTap(e);
                return true;
            }

            @Override
            public boolean onDown(MotionEvent e) {
                return true;
            }
        });

        // Set a touch listener on the Scene to listen for taps.
        arSceneView.getScene()
                   .setOnTouchListener((HitTestResult hitTestResult, MotionEvent event) -> gestureDetector.onTouchEvent(event));

        // Set an update listener on the Scene that will hide the loading message once a Plane is
        // detected.
        arSceneView.getScene()
                   .addOnUpdateListener(frameTime -> {
                       if (loadingMessageSnackbar == null) {
                           return;
                       }

                       Frame frame = arSceneView.getArFrame();
                       if (frame == null) {
                           return;
                       }

                       if (frame.getCamera()
                                .getTrackingState() != TrackingState.TRACKING) {
                           return;
                       }

                       for (Plane plane : frame.getUpdatedTrackables(Plane.class)) {
                           if (plane.getTrackingState() == TrackingState.TRACKING) {
                               hideLoadingMessage();
                           }
                       }
                   });

        // Lastly request CAMERA permission which is required by ARCore.
        DemoUtils.requestCameraPermission(this, RC_PERMISSIONS);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (arSceneView == null) {
            return;
        }

        if (arSceneView.getSession() == null) {
            // If the session wasn't created yet, don't resume rendering.
            // This can happen if ARCore needs to be updated or permissions are not granted yet.
            try {
                Session session = DemoUtils.createArSession(this, installRequested);
                if (session == null) {
                    installRequested = DemoUtils.hasCameraPermission(this);
                    return;
                } else {
                    arSceneView.setupSession(session);
                }
            } catch (UnavailableException e) {
                DemoUtils.handleSessionException(this, e);
            }
        }

        try {
            arSceneView.resume();
        } catch (CameraNotAvailableException ex) {
            DemoUtils.displayError(this, "Unable to get camera", ex);
            finish();
            return;
        }

        if (arSceneView.getSession() != null) {
            showLoadingMessage();
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        if (arSceneView != null) {
            arSceneView.pause();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (arSceneView != null) {
            arSceneView.destroy();
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        finish();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] results) {
        if (!DemoUtils.hasCameraPermission(this)) {
            if (!DemoUtils.shouldShowRequestPermissionRationale(this)) {
                // Permission denied with checking "Do not ask again".
                DemoUtils.launchPermissionSettings(this);
            } else {
                Toast.makeText(this, "Camera permission is needed to run this application", Toast.LENGTH_LONG)
                     .show();
            }
            finish();
        }
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            // Standard Android full-screen functionality.
            getWindow().getDecorView()
                       .setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION |
                                              View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
                                              View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        }
    }

    private void onSingleTap(MotionEvent tap) {
        if (!hasFinishedLoading) {
            // We can't do anything yet.
            return;
        }

        Frame frame = arSceneView.getArFrame();
        if (frame != null) {
            if (!hasPlacedDocumentSystem && tryPlaceDocumentSystem(tap, frame)) {
                hasPlacedDocumentSystem = true;
            }
        }
    }

    private boolean tryPlaceDocumentSystem(MotionEvent tap, Frame frame) {
        if (tap != null && frame.getCamera()
                                .getTrackingState() == TrackingState.TRACKING) {
            for (HitResult hit : frame.hitTest(tap)) {
                Trackable trackable = hit.getTrackable();
                if (trackable instanceof Plane && ((Plane) trackable).isPoseInPolygon(hit.getHitPose())) {
                    // Create the Anchor.
                    Anchor anchor = hit.createAnchor();
                    AnchorNode anchorNode = new AnchorNode(anchor);
                    anchorNode.setParent(arSceneView.getScene());
                    Node documentSystem = createDocumentSystem();
                    anchorNode.addChild(documentSystem);
                    return true;
                }
            }
        }

        return false;
    }

    private Node createDocumentSystem() {
        Node base = new Node();

        Node documentObject = new Node();
        documentObject.setParent(base);
        documentObject.setRenderable(documentRenderable);
        documentObject.setLocalPosition(new Vector3(0.0f, 0.3f, 0.0f));

        return base;
    }

    private void showLoadingMessage() {
        if (loadingMessageSnackbar != null && loadingMessageSnackbar.isShownOrQueued()) {
            return;
        }

        loadingMessageSnackbar =
                Snackbar.make(DocumentActivity.this.findViewById(android.R.id.content), R.string.plane_finding, Snackbar.LENGTH_INDEFINITE);
        loadingMessageSnackbar.getView()
                              .setBackgroundColor(0xbf323232);
        loadingMessageSnackbar.show();
    }

    private void hideLoadingMessage() {
        if (loadingMessageSnackbar == null) {
            return;
        }

        loadingMessageSnackbar.dismiss();
        loadingMessageSnackbar = null;
    }

    private String getIntentStringForKey(String key) {
        if (getIntent().hasExtra(key)) {
            return getIntent().getStringExtra(key);
        }
        return "";
    }

    private Bitmap getBitmapFromString(String encodedImage) {
        byte[] decodedString = Base64.decode(encodedImage, Base64.DEFAULT);
        return BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
    }
}
