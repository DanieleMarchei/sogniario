import { NestFactory } from "@nestjs/core";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { AppModule } from "./app.module";
import * as fs from "fs";
import helmet from "helmet";

async function bootstrap() {
  // console.log(process.cwd());
  //Production
  const httpsOptions = {
    key: fs.readFileSync(process.cwd() + process.env.KEY_PATH),
    cert: fs.readFileSync(
      process.cwd() + process.env.CERT_PATH
    ),
    passphrase: process.env.CERT_PWD
  };
  const app = await NestFactory.create(AppModule, {
    httpsOptions,
  });

  
  //development
  // const app = await NestFactory.create(AppModule);
  
  app.use(helmet());

  const config = new DocumentBuilder()
    .setTitle("Sognario API description")
    .setDescription(
      "Documentation provided by @micrus and @DanieleMarchei for the Sogniario API, this will serve as a central point for the frontend depelopers to retrive all the required information in order to continue the work."
    )
    .setVersion("1.0")
    .addBearerAuth()
    .build();

  const options2 = {
    // customCss: '.swagger-ui .topbar { display: none }'
    customCss: `
        .topbar-wrapper img {content:url(\'https://upload.wikimedia.org/wikipedia/it/b/bd/Logo_unicam.png'); width:50px; height:auto;}
        `,
  };

  const document = SwaggerModule.createDocument(app, config);
  //SwaggerModule.setup("api", app, document, options2);
  app.enableCors({
    origin: true,
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS",
  });

  await app.listen(8765);
}
bootstrap();
