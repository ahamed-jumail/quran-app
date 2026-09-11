import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")
    //update according to project flavors
    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.example.flutter_bloc_bp"
            resValue(type = "string", name = "app_name", value = "[Dev] App")
        }
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.example.flutter_bloc_bp"
            resValue(type = "string", name = "app_name", value = "[Staging] App")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.example.flutter_bloc_bp"
            resValue(type = "string", name = "app_name", value = "Flutte BP")
        }
    }
}