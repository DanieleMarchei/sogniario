"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const swagger_1 = require("@nestjs/swagger");
const app_module_1 = require("./app.module");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    const config = new swagger_1.DocumentBuilder()
        .setTitle("Sognario API description")
        .setDescription("Documentation provided by @micrus and @DanieleMarchei for the Sogniario API, this will serve as a central point for the frontend depelopers to retrive all the required information in order to continue the work.")
        .setVersion("1.0")
        .build();
    const options2 = {
        customCss: `
        .topbar-wrapper img {content:url(\'https://upload.wikimedia.org/wikipedia/it/b/bd/Logo_unicam.png'); width:50px; height:auto;}
        `,
    };
    const document = swagger_1.SwaggerModule.createDocument(app, config);
    swagger_1.SwaggerModule.setup("api", app, document, options2);
    await app.listen(3000);
}
bootstrap();
//# sourceMappingURL=main.js.map