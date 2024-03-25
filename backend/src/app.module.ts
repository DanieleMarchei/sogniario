import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { TypeOrmModule } from "@nestjs/typeorm";
import { User } from "./entities/user.entity";
import { UserModule } from "./User/user.module";
import { Dream } from "./entities/dream.entity";

import { DreamModule } from "./Dream/dream.module";
import { PsqiModule } from "./Psqi/psqi.module";
import { Chronotype } from "./entities/chronotype.entity";
import { ChronotypeModule } from "./Chronotype/chronotype.module";
import { Psqi } from "./entities/psqi.entity";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRoot({
      type: "postgres",
      host: process.env.DATABASE_HOST,
      port: +process.env.DATABASE_PORT,
      username: process.env.DATABASE_USER,
      password: process.env.DATABASE_PASSWORD,
      database: process.env.DATABASE_NAME,
      entities: [User, Dream, Chronotype, Psqi],
      synchronize: true,
    }),
    UserModule,
    DreamModule,
    PsqiModule,
    ChronotypeModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
