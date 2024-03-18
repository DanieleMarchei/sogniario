import { NestFactory } from "@nestjs/core";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { AppModule } from "./app.module";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
    .setTitle("Sognario API description")
    .setDescription(
      "Documentation provided by @micrus and @DanieleMarchei for the Sogniario API, this will serve as a central point for the frontend depelopers to retrive all the required information in order to continue the work."
    )
    .setVersion("1.0")

    .build();

  const options2 = {
    // customCss: '.swagger-ui .topbar { display: none }'
    customCss: `
        .topbar-wrapper img {content:url(\'https://upload.wikimedia.org/wikipedia/it/b/bd/Logo_unicam.png'); width:50px; height:auto;}
        `,
  };

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("api", app, document, options2);

  await app.listen(3000);
}
bootstrap();
