//
//  Client.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/15/23.
//

import NIO
import SotoCore
import SotoS3

class S3Client {
  let client: AWSClient
  let s3: S3

  init() {
    self.client = AWSClient(
      credentialProvider: .static(accessKeyId: "123", secretAccessKey: "123"),
      httpClientProvider: .createNew
    )
    self.s3 = S3(client: client, region: .uswest2)
  }

  func listBucketNames() -> EventLoopFuture<[String]> {
    let future = s3.listBuckets(logger: Logger(label: "Logger"))

    return future.map { response in
      return response.buckets?.compactMap { $0.name } ?? []
    }
  }
}
