import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { PsqiController } from "./psqi.controller";
import { PsqiService } from "./psqi.service";
import { Psqi } from "src/entities/psqi.entity";

@Module({
  imports: [TypeOrmModule.forFeature([Psqi])],
  controllers: [PsqiController],
  providers: [PsqiService],
})
export class PsqiModule {}
