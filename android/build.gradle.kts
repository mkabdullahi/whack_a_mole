allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// // Example of a properly aligned android block (uncomment and configure as needed)
// android {
//     compileSdk = 27
//     defaultConfig {
//         applicationId = "com.mkabdullahi.whack_a_mole"
//         minSdk = 21
//         targetSdk = 33
//         versionCode = 1
//         versionName = "1.0"
//     }
// }
