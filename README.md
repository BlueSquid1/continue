# Continue

**Source-controlled AI checks, enforceable in CI**

This is Clinton's version that is gear towards running local LLMs.

## Build

docker run -it --rm -v "$(pwd):$(pwd)" -w "$(pwd)" node /bin/bash ./build.sh

## Things I have learnt reading this repo:

- Why does keep on reprompting the LLM when I do a force autocomplete? - debounce is activated. Could solve by increasing debounce
- Why does my autocomplete keep on cancelling? it's because the model timeout keeps on occuring. Can increase the number in the agents yaml file.
- How can I make it only trigger from a keyboard shortcut? - can set the debounce it the max value of 2147483647
- Why does it keep on generating after finishing the prompt? - this is the LLM fault. It's not the best at working out when it should stop.
- How does it know what part is not relevant? - has a bunch of fixed checks. Most useful one is the one that stops when it incounters a blank newline.
- Can I get it to cancel generating the prompt if it knows it's done? - add a call to fullStop(); in generation/completionStreamer.ts:87
- why does it sometimes not trigger when I press Ctrl + space? - bug in vscode/src/autocomplete/CompletionProvider.ts:346 where the nextEditProvider hijacks the invoke because it has a chain from the completionProvider. need to set chainExists to false as a work around.
- Why does it not always present the answer in grey? - VSCode sends a CancellationToken because the provider takes too long. Short term fix is to ignore abort signal by commenting out line CompletionStreamer.ts:63, CompletionProvider.ts:254 abort check and reinvoke provider in commands.ts:585.

core/CompletionProvider.ts - managers autocomplete, line 136 generates autoconfig config
core/index.d.ts - defines TabAutocompleteOptions
loadYaml.ts - looks like configYamlToContinueConfig() has no way to populate tabAutocompleteOptions which contains the max prompt length

core/CompletionProvider.ts:244 - read and process the Ollama stream
completionStreamer.ts:80 - create the streamer with all the fitlers on when to stop.
completionStreamer.ts:31 - then creates the streamer that connect to Ollama
completionStreamer.ts:47 - wrap it in a stopAfterMaxProcessingTime() which will call fullStop() when time limit has been reached
llm/index.ts:607 - invoked when a new FIR request is created
llm.Ollama.ts:657 - Sends POST request and gets response from local LLM as a stream
vscode/src/autocomplete/CompletionProvider.ts:524 - determines if should display on the IDE

VsCodeExtension.ts:368 - register vscode/../CompletionProvider.ts as a InlineCompletionItemProvider
VsCodeExtension.ts:507 - calls core/CompletionProvider.ts provideInlineCompletionItems()

## License

[Apache 2.0 © 2023-2024 Continue Dev, Inc.](./LICENSE)
