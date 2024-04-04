import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { ResearcherController } from "./researcher.controller";
import { ResearcherService } from "./researcher.service";
import { Researcher } from "src/entities/researcher.entity";

@Module({
  imports: [TypeOrmModule.forFeature([Researcher])],
  controllers: [ResearcherController],
  providers: [ResearcherService],
  exports: [ResearcherService],
})
export class ResearcherModule {}
