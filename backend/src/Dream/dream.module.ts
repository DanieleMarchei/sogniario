import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { DreamController } from "./dream.controller";
import { DreamService } from "./dream.service";
import { Dream } from "src/entities/dream.entity";

@Module({
  imports: [TypeOrmModule.forFeature([Dream])],
  controllers: [DreamController],
  providers: [DreamService],
})
export class DreamModule {}
