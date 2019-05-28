node {
stage("clone repository") {
        checkout scm
}
    stage("composer_install") {
        // Run `composer update` as a shell script
        sh 'composer install'
    }
    stage("phpunit") {
        // Run PHPUnit
        sh './vendor/bin/phpunit tests/Unit/ExampleTest.php'
    }
}
