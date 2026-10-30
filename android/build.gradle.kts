allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// cbl_flutter y cbl_flutter_ce fijan un compileSdk menor al que piden sus dependencias.
// Tiene que ir antes de evaluationDependsOn para alcanzar a registrar afterEvaluate.
subprojects {
    if (name == "cbl_flutter" || name == "cbl_flutter_ce") {
        afterEvaluate {
            extensions.findByType(com.android.build.api.dsl.LibraryExtension::class.java)?.compileSdk = 36
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
